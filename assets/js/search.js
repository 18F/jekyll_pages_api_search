/* jshint node: true */

'use strict';

var lunr = require('lunr');
var querystring = require('querystring');
var url = require('url');

var SEARCH_INPUT_ID = 'search-input';
var SEARCH_RESULTS_ID = 'search-results';

function fetchIndex(baseUrl) {
  return new Promise(function(resolve, reject) {
    var req = new XMLHttpRequest(),
        indexUrl = baseUrl + '/search-index.json';

    req.addEventListener('load', function() {
      var rawJson;

      try {
        rawJson = JSON.parse(this.responseText);
        resolve({
          urlToDoc: rawJson.url_to_doc,
          index: lunr.Index.load(rawJson.index)
        });
      } catch (err) {
        reject(new Error('failed to parse ' + indexUrl));
      }
    });
    req.open('GET', indexUrl);
    req.send();
  });
}

function parseSearchQuery(queryUrl) {
  return querystring.parse(url.parse(queryUrl).query).q;
}

function getResults(query, searchIndex) {
  var results = searchIndex.index.search(query);

  results.forEach(function(result) {
    var urlAndTitle = searchIndex.urlToDoc[result.ref];

    Object.keys(urlAndTitle).forEach(function(key) {
      result[key] = urlAndTitle[key];
    });
  });
  return results;
}

function writeResults(searchQuery, doc, searchBox, resultsList, results) {
  if (searchQuery) {
    searchBox.value = searchQuery;
  }
  results.forEach(function(result) {
    var item = doc.createElement('li'),
        link = doc.createElement('a'),
        text = doc.createTextNode(result.title);

    link.appendChild(text);
    link.title = result.title;
    link.href = result.url;
    item.appendChild(link);
    resultsList.appendChild(item);
  });
}

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

module.exports = function() {
  var doc = window.document,
      inputElement = doc.getElementById(SEARCH_INPUT_ID),
      searchUi = new SearchUi(doc, inputElement),
      resultsElement = doc.getElementById(SEARCH_RESULTS_ID);

  searchUi.enableGlobalShortcut();

  if (!resultsElement) {
    return;
  }

  return fetchIndex(window.SEARCH_BASEURL)
    .then(function(searchIndex) {
      var query = parseSearchQuery(window.location.href),
          results = getResults(query, searchIndex);
      writeResults(query, doc, inputElement, resultsElement, results);
    })
    .catch(function(error) {
      console.error(error);
    });
}();
