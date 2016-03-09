'use strict';

module.exports = SearchUi;

// eslint-disable-next-line
// based on https://github.com/angular/angular.js/blob/54ddca537/docs/app/src/search.js#L198-L206
function SearchUi(doc, inputElement) {
  var isForwardSlash = function(keyCode) {
    return keyCode === 191;
  };

  var isInput = function(el) {
    return el.tagName.toLowerCase() === 'input';
  };

  var giveSearchFocus = function() {
    inputElement.focus();
  };

  var onKeyDown = function(event) {
    if (isForwardSlash(event.keyCode) && !isInput(doc.activeElement)) {
      event.stopPropagation();
      event.preventDefault();
      giveSearchFocus();
    }
  };

  this.enableGlobalShortcut = function() {
    doc.body.onkeydown = onKeyDown;
  };
}

SearchUi.DEFAULT_SEARCH_INPUT_ID = 'search-input';
SearchUi.DEFAULT_SEARCH_RESULTS_ID = 'search-results';
