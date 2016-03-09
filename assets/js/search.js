/* eslint-env browser, node */

'use strict';

var SearchEngine = require('./search-engine');
var SearchUi = require('./search-ui');

function writeResults(query, results, doc, resultsList) {
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
  var searchUi = new SearchUi(window.document),
      searchEngine = new SearchEngine();

  searchUi.enableGlobalShortcut();

  if (!searchUi.resultsElement) {
    return;
  }

  return searchEngine.executeSearch(window.SEARCH_BASEURL, window.location.href)
    .then(function(searchResults) {
      searchUi.renderResults(searchResults.query, searchResults.results,
        writeResults);
    })
    .catch(function(error) {
      console.error(error);
    });
}();
