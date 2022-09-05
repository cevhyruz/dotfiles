defaults: {
    scrollStepSize: 60,
    smoothScroll: true,
    keyMappings: "# Insert your preferred key mappings here.",
    linkHintCharacters: "sadfjklewcmpgh",
    linkHintNumbers: "0123456789",
    filterLinkHints: false,
    hideHud: false,
    userDefinedLinkHintCss:
      `\
div > .vimiumHintMarker {
/* linkhint boxes */
background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#FFF785),
  color-stop(100%,#FFC542));
border: 1px solid #E3BE23;
}

div > .vimiumHintMarker span {
/* linkhint text */
color: black;
font-weight: bold;
font-size: 12px;
}

div > .vimiumHintMarker > .matchingCharacter {
}\
`,
    // Default exclusion rules.
    exclusionRules:
      [
        // Disable Vimium on Gmail.
        { pattern: "https?://mail.google.com/*", passKeys: "" }
      ],

    // NOTE: If a page contains both a single angle-bracket link and a double angle-bracket link, then in
    // most cases the single bracket link will be "prev/next page" and the double bracket link will be
    // "first/last page", so we put the single bracket first in the pattern string so that it gets searched
    // for first.

    // "\bprev\b,\bprevious\b,\bback\b,<,‹,←,«,≪,<<"
    previousPatterns: "prev,previous,back,older,<,\u2039,\u2190,\xab,\u226a,<<",
    // "\bnext\b,\bmore\b,>,›,→,»,≫,>>"
    nextPatterns: "next,more,newer,>,\u203a,\u2192,\xbb,\u226b,>>",
    // default/fall back search engine
    searchUrl: "https://www.google.com/search?q=",
    // put in an example search engine
    searchEngines:
      `\
w: https://www.wikipedia.org/w/index.php?title=Special:Search&search=%s Wikipedia

# More examples.
#
# (Vimium supports search completion Wikipedia, as
# above, and for these.)
#
# g: https://www.google.com/search?q=%s Google
# l: https://www.google.com/search?q=%s&btnI I'm feeling lucky...
# y: https://www.youtube.com/results?search_query=%s Youtube
# gm: https://www.google.com/maps?q=%s Google maps
# b: https://www.bing.com/search?q=%s Bing
# d: https://duckduckgo.com/?q=%s DuckDuckGo
# az: https://www.amazon.com/s/?field-keywords=%s Amazon
# qw: https://www.qwant.com/?q=%s Qwant\
`,
    newTabUrl: "about:newtab",
    grabBackFocus: false,
    regexFindMode: false,
    waitForEnterForFilteredHints: false, // Note: this defaults to true for new users; see below.

    settingsVersion: "",
    helpDialog_showAdvancedCommands: false,
    optionsPage_showAdvancedOptions: false,
    passNextKeyKeys: [],
    ignoreKeyboardLayout: false
  }
