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

(function(window, util, gh) {
  'use strict'


  let Github = {
    _get_author: function() {
      return document.getElementsByClassName('url')[0].textContent
    },
    _get_repoName: function() {
      return document.getElementsByClassName('flex-self-stretch')[4]
        .childNodes[1].textContent
    },

    ssh: function() {
      return `git@github.com:${Github._get_author()}/${Github._get_repoName()}.git`
    },

    https: function() {
      return `https://github.com/${Github._get_author()}/${Github._get_repoName()}.git`
    },

    packer: function() {
      return `${Github._get_author()}/${Github._get_repoName()}`
    },

    clone: function(format) {
      try {
        util.popUp( util.yank(this[format].apply()) )
      } catch(error) {
        util.popUp(error)
      }
    },
  }

  window.Github = Github;

}(window, window.Util, window.Github));
