// ==UserScript==
// @name         util.js
// @description  Utility to provide helper functions for scripting userscripts.
// @version      0.1
//
// @author       cevhyruz <johnfred.fadrigalan@hotmail.com>
// @namespace    dotfiles.userscripts
//
// @updateURL    https://raw.githubusercontent.com/cevhyruz/dotfiles/master/userscripts/util.js
// @downloadURL  https://raw.githubusercontent.com/cevhyruz/dotfiles/master/userscripts/util.js
//
// @match        *://*/*
// @require      file:///home/devs/Projects/dotfiles/userscripts/util.js
//
// @run-at       document-start
// @grant        none
// ==/UserScript==

(function(window) {
  'use strict'

  alert('does update works?')

  let Util = {

    create: function(tag, props) {
      return Object.assign(document.createElement(tag), props);
    },

    snackbar: function() { },

    yank: function() { },

    log: function() { }

  }

  window.Util = Util

}(window));
