// ==UserScript==
// @name         Studocu preview banner remover
// @namespace    http://tampermonkey.net/
// @version      2024-03-06
// @description  try to take over the world!
// @author       You
// @match        https://www.studocu.com/ph/document/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=studocu.com
// @run-at      document-start
// @grant        none
// ==/UserScript==

window.addEventListener('load', function() {
  const prevBanner = document.querySelectorAll('._9fcb6a94a9ec._0464070431ae ');
  prevBanner.forEach(prevBanner => { prevBanner.style.display = 'none' });


 // const bannerSideDecors = document.querySelectorAll('._60e676a00207');
 const bannerSideDecors = document.querySelectorAll('._d090be426bcb');
  bannerSideDecors.forEach(bannerSideDecors => { bannerSideDecors.style.display = 'none' })

}, false);
