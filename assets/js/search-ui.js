'use strict';

module.exports = SearchUi;

// eslint-disable-next-line
// based on https://github.com/angular/angular.js/blob/54ddca537/docs/app/src/search.js#L198-L206
function SearchUi(doc, options) {
  var opts = options || {};

  this.doc = doc;
  this.inputElement = doc.getElementById(
    opts.inputElementId || SearchUi.DEFAULT_SEARCH_INPUT_ID);
  this.resultsElement = doc.getElementById(
    opts.searchResultsId || SearchUi.DEFAULT_SEARCH_RESULTS_ID);
}

SearchUi.DEFAULT_SEARCH_INPUT_ID = 'search-input';
SearchUi.DEFAULT_SEARCH_RESULTS_ID = 'search-results';

function isForwardSlash(keyCode) {
  return keyCode === 191;
}

function isInput(element) {
  return element.tagName.toLowerCase() === 'input';
}

SearchUi.prototype.enableGlobalShortcut = function() {
  var doc = this.doc,
      inputElement = this.inputElement;

  doc.body.onkeydown = function(event) {
    if (isForwardSlash(event.keyCode) && !isInput(doc.activeElement)) {
      event.stopPropagation();
      event.preventDefault();
      inputElement.focus();
    }
  };
};

SearchUi.prototype.renderResults = function(query, results, renderResults) {
  if (!query) {
    return;
  }
  this.inputElement.value = query;
  renderResults(results, this.doc, this.resultsElement);
};
