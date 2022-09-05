// ==UserScript==
// @name         util.js
// @description  Utility to provide helper functions for scripting userscripts.
// @version      0.1
//
// @author       cevhyruz <johnfred.fadrigalan@hotmail.com>
// @namespace    dotfiles.userscripts
//
// @match        *://*/*
// @require      file:///home/devs/Projects/dotfiles/userscripts/util.js
//
// @run-at       document-start
// @grant        none
// ==/UserScript==
//

(function(window) {
  'use strict'

  let Util = {

    _create: function(tag, props) {
      return Object.assign(document.createElement(tag), props);
    },

    popUp: function(message) {
      // create the snackbar
      let snackbar = this._create('div', {
        id: 'snackbar',
        className: 'show',
        textContent: message
      });
      document.body.appendChild(snackbar)
      document.documentElement.appendChild( this._create('style', { 
        textContent: /*language=CSS*/`
        #snackbar {
          visibility: hidden;
          background-color: #7ed6df;
          color: #333333;
          min-width: 250px;
          margin: 0 auto;
          text-align: center;
          border-radius: 2px;
          padding: 13px;
          position: fixed;
          left: 5px;
          z-index: 1;
          bottom: 5px;
          font-size: 15px;
        }
        #snackbar.show {
          visibility: visible;
          -webkit-animation: fadein 0.5s, fadeout 0.5s 2.5s;
          animation: fadein 0.5s, fadeout 0.5s 2.5s;
        }
        @-webkit-keyframes fadein {
          from {bottom: 0; opacity: 0;}
          to {bottom: 5px; opacity: 1;}
        }
        @keyframes fadein {
          from {bottom: 0; opacity: 0;}
          to {bottom: 5px; opacity: 1;}
        }
        @-webkit-keyframes fadeout {
          from {bottom: 5px; opacity: 1;}
          to {bottom: 0; opacity: 0;}
/el       }
        @keyframes fadeout {
          from {bottom: 5px; opacity: 1;}
          to {bottom: 0; opacity: 0;}
        } `
      }) );
      setTimeout(function() {
        snackbar.className = snackbar.className.replace('show', '');
        snackbar.remove()
      }, 3000)
    },

    yank: function(string) {
      let register = this._create('textArea', { style: {
        position: 'absolute',
        top: 0,
        left: 0
      } })
      document.body.appendChild(register)
      register.value = string;
      register.select();
      try {
        document.execCommand('copy')
      } catch(err) {
        console.log('something went wrong')
      }
      register.remove();
      return string
    },

  }

  window.Util = Util

}(window));
