// ==UserScript==
// @name         github-clone-repo
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  Project-specific script for github.
// @author       You
// @match        https://github.com/**/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=github.com
// @grant        none
// ==/UserScript==

console.log('Github')
(function(window, util) {
  'use strict';

  let Github = {

    metadata: {
      author: document.getElementsByClassName('url')[0].textContent,
      repository: document.getElementsByClassName('flex-self-stretch')[4].childNodes[1].textContent
    },

    gotoPage: function() {

    },

    yankClonePath: function(type) {
      let path = this.metadata.author + '/' + this.metadata.repository,
          head = type ? 'gist@github.com:' : 'https://github.com/',
          tail = '.git';

      let completePath = head + path + tail;

      try {
        util.yank(completePath)
        util.log('')
        return completePath
      } catch(err) {
        console.log('Github: Cannot yank path', err)
      }
    },

  }

  window.Github = Github;

}(window, window.Util));
