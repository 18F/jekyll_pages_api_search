/* eslint-env browser, node */

'use strict';

var SearchEngine = require('./search-engine');
var SearchUi = require('./search-ui');

function writeResults(searchQuery, doc, searchBox, resultsList, results) {
  if (searchQuery) {
    searchBox.value = searchQuery;
  }
  results.forEach(function(result, index) {
    var item = doc.createElement('li'),
        link = doc.createElement('a'),
        text = doc.createTextNode(result.title);

    link.appendChild(text);
    link.title = result.title;
    link.href = result.url;
    item.appendChild(link);
    resultsList.appendChild(item);

    link.tabindex = index;
    if (index === 0) {
      link.focus();
    }
  });
}

module.exports = function() {
  var doc = window.document,
      inputElement = doc.getElementById(SearchUi.DEFAULT_SEARCH_INPUT_ID),
      searchUi = new SearchUi(doc, inputElement),
      resultsElement = doc.getElementById(SearchUi.DEFAULT_SEARCH_RESULTS_ID),
      searchEngine = new SearchEngine();

  searchUi.enableGlobalShortcut();

  if (!resultsElement) {
    return;
  }

  return searchEngine.executeSearch(window.SEARCH_BASEURL, window.location.href)
    .then(function(searchResults) {
      writeResults(searchResults.query, doc, inputElement, resultsElement,
        searchResults.results);
    })
    .catch(function(error) {
      console.error(error);
    });
};
