/* jshint node: true */

'use strict';

var lunr = require('lunr');

function fetchIndex(baseUrl) {
  return new Promise(function(resolve, reject) {
    var req = new XMLHttpRequest(),
        indexUrl = baseUrl + '/search-index.json';

    req.addEventListener('load', function() {
      var rawJson;

      try {
        rawJson = JSON.parse(this.responseText);
        resolve({
          url_to_doc: rawJson.url_to_doc,
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

function makeSearchCallback(inputElement, searchIndex) {
  return function() {
    var term = inputElement.value.trim(),
        results;

    if (term.length <= 3) {
      return;
    }
    console.log('term is:', term);

    results = searchIndex.index.search(term);
    results.forEach(function(result) {
      var page = searchIndex.url_to_doc[result.ref];
      result.page = page;
      result.displayTitle = page.title || page.url;
    });
    console.log('results are:', results);
    return results;
  };
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

  this.getSelectedResult = function() {
    var resultsPane = doc.getElementById('search-results');
    console.log('TODO: hook up', resultsPane);
  };
}

function SearchController(controllerElement, searchUi, getResults) {
  searchUi.enableGlobalShortcut();

  var isEnter = function(keyCode) {
    return keyCode === 13;
  };

  controllerElement.onkeydown = function(someEvent) {
    if (isEnter(someEvent.keyCode)) {
      var result = searchUi.getSelectedResult();
      console.log('TODO: window.location = result.page.url');
    }
  };

  controllerElement.onkeyup = function() {
    return new Promise(function(resolve) {
      resolve(getResults());
    });
  };
}

module.exports = function() {
  var doc = window.document;

  return fetchIndex(window.SEARCH_BASEURL)
    .then(function(searchIndex) {
      var inputElement = doc.getElementById('search1');

      return new SearchController(
        doc.getElementById('search-controller'),
        new SearchUi(doc, inputElement),
        makeSearchCallback(inputElement, searchIndex));
    })
    .catch(function(error) {
      console.error(error);
    });
}();
