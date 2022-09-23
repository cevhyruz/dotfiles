// ==UserScript==
// @name         youtube.com.js
// @description  Remove all adds youtube ads.
// @version      0.1
//
// @author       cevhyruz <johnfred.fadrigalan@hotmail.com>
// @namespace    dotfiles.userscripts
//
// @match        https://www.youtube.com/*
// @require      file:///home/devs/Projects/dotfiles/userscripts/youtube.com.js
// @run-at       document-idle
//
// @grant        none
// ==/UserScript==

(function(window, util) {
  'use strict'

  setTimeout(function() {
    let parent = document.getElementById('alerts')

    parent.appendChild(util._create('button', {
      textContent: 'Download Video (MP4)',
      id: 'mybutton'
    }))

    document.documentElement.appendChild( util._create('style', {
      textContent: /*language=CSS*/ `
      button#mybutton {
        height: 50px:
        width:  200px:
        background-color: red;
      }
      `
    }))
  }, 10000)



}(window, window.Util));
