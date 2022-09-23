// ==UserScript==
// @name        GitHub file list beautifier
// @description Adds colors to files by type, displays small images in place of file-type icons in a repository source tree
// @license     MIT License
//
// @version     3.0.10
//
// @match       https://github.com/*
//
// @grant       none
// @run-at      document-start
//
// @author      wOxxOm
// @namespace   wOxxOm.scripts
// @icon        https://octodex.github.com/images/murakamicat.png
// ==/UserScript==

'use strict';


let savedConfig = {};
try { savedConfig = JSON.parse(localStorage.FileListBeautifier) || {};
} catch(e) {}

const config = Object.assign({},
  ...Object.entries({
    iconSize: 8,
    colorSeed1: 13,
    colorSeed2: 1299721,
    colorSeed3: 179426453,
  })
  .map(([k, v]) => ({
    [k]: +savedConfig[k] || v
  })));

const IMG_CLS = 'wOxxOm-image-icon';
const styleQueue = [];
const {sheet} = document.documentElement.appendChild( $create('style', {
  textContent: /*language=CSS*/ `
  .${IMG_CLS} {
    max-width: ${config.iconSize}px;
    max-height: ${config.iconSize}px;
    width: auto;
    height: auto;
    margin: auto;
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
  }
  .wOxxOm-image-cell {
    position: relative;
    padding: 0;
    margin: 0 10px 0 -6px;
    min-width: ${config.iconSize + 4}px;
    line-height: inherit;
  }
  .wOxxOm-image-cell svg {
    display: none;
  }
  a[file-type=":folder"] {
    font-weight: bold;
  }
  `.replace(/;/g, '!important;'),
}));

const filetypes = {};
const ME = Symbol(GM_info.script.name);
const ob = new MutationObserver(() => {
  if (document.getElementById('files')) {
    ob.disconnect();
    start();
  }
});

let lumaBias, lumaFix, lumaAmp;

start();

function start() {
  beautify();
  ob.observe(document, {
    subtree: true,
    childList: true
  });
}

// postpone observing until the parser can breathe after the initial burst of activity during page load
function beautify() {
  const el = document.getElementById('files');

  const table = el && el.parentElement.querySelector('.js-navigation-container');

  if (!table) { return; }

  for (const a of table.getElementsByClassName('js-navigation-open')) {
    if (!a.hasAttribute('href') || ME in a)
      continue;
    a[ME] = true;

    // folder
    const row = a.closest('.js-navigation-item');
    if (row && row.querySelector('.octicon-file-directory')) {
      a.setAttribute('file-type', ':folder');
      continue;
    }

    // files
    const ext = a.href.match(/\.(\w+)$|$/)[1] || ':empty';
    a.setAttribute('file-type', ext);
    if (!filetypes[ext]) {
      addFileTypeStyle(ext);
    }

    // image icon
    if (/^(png|jpe?g|bmp|gif|cur|ico|svg)$/.test(ext)) {
      const m = a.href.match(/github\.com\/(.+?\/)blob\/(.*)$/);
      const icon = row.querySelector('.octicon');
      const next = icon && icon.nextElementSibling;
      if (!m || !icon || next && next.classList.contains(IMG_CLS))
        continue;
      icon.insertAdjacentElement('afterend', $create('img', {
        className: IMG_CLS,
        src: `https://raw.githubusercontent.com/${m[1]}${m[2]}`,
      }));
      icon.parentElement.classList.add('wOxxOm-image-cell');
    }
  }
}

function addFileTypeStyle(type) {
  filetypes[type] = true;
  if (!styleQueue.length)
    requestAnimationFrame(commitStyleQueue);
  styleQueue.push(type);
}

function commitStyleQueue() {
  if (!lumaAmp) initLumaScale();
  const seed2 = config.colorSeed2;
  const seed3 = config.colorSeed3;
  for (const type of styleQueue) {
    const hash = calcSimpleHash(type);
    const H = hash % 360;
    const Hq = H / 60;
    const S = hash * seed2 % 50 + 50 | 0;
    const redFix = (Hq < 1 ? 1 - Hq : Hq > 4 ? (Hq - 4) / 2 : 0);
    const blueFix = (Hq < 3 || Hq > 5 ? 0 : Hq < 4 ? Hq - 3 : 5 - Hq) * 3;
    const L = hash * seed3 % lumaAmp + lumaBias + (redFix + blueFix) * lumaFix * S / 100 | 0;
    sheet.insertRule(/*language=CSS*/ `
      a[file-type="${type}"]:not(#foo) {
        color: hsl(${H},${S}%,${L}%) !important;
      }
    `);
  }
  styleQueue.length = 0;
}

function calcSimpleHash(text) {
  let hash = 0;
  for (let i = 0, len = text.length; i < len; i++)
    hash = ((hash << 5) - hash) + text.charCodeAt(i);
  return Math.abs(hash * config.colorSeed1 | 0);
}

function initLumaScale() {
  const [, r, g, b] = getComputedStyle(document.body).backgroundColor.split(/[^\d.]+/).map(parseFloat);
  const isDark = (r * .2126 + g * .7152 + b * .0722) < 128;
  [lumaBias, lumaAmp, lumaFix] = isDark ? [30, 50, 12] : [25, 15, 0];
}

function $create(tag, props) {
  return Object.assign(document.createElement(tag), props);
}
