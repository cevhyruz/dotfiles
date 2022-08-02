// ==UserScript==
// @name         github.com.js
// @description  Usersript to make github much better.
// @version      0.1
//
// @author       cevhyruz <johnfred.fadrigalan@hotmail.com>
// @namespace    dotfiles.userscripts
//
// @match        https://github.com/**/*
// @require      file:///home/devs/Projects/dotfiles/userscripts/github.com.js
//
// @grant        none
// ==/UserScript==
//


(function(window, util) {
  'use strict'

  let Github = {

    metadata: {
      author: document.getElementsByClassName('url')[0].textContent,
      projectName: document.getElementsByClassName('flex-self-stretch')[4].childNodes[1].textContent
    },

    init: function() {
    },

    yankClonePath: function(string) {
      let path = this.metadata.author + '/' + this.metadata.projectName,
          head = string ? 'git@github.com:' : 'https://github.com/',
          tail = '.git';
      let completePath = head + path + tail
      try {
        util.yank(completePath)
        util.popUp("yanked: " + completePath)
      } catch(err) {
        util.popUp('Something went wrong while yanking', err)
      }
    },
  }

  Github.init()
  window.Github = Github;


}(window, window.Util));
