/* global lunr buildIndex:true */
/* eslint no-unused-vars: [2, { "vars": "local" }] */

buildIndex = function(corpus, indexFields) {
  var index = lunr(function() {
    this.ref('url');

    for (var fieldName in indexFields) {
      var boost = indexFields[fieldName];
      this.field(fieldName, boost);
    }
  });

  var urlToDoc = {};

  corpus.entries.forEach(function(page) {
    if (page.skip_index !== true) {
      index.add(page);
      urlToDoc[page.url] = {url: page.url, title: page.title};
    }
  });

  return JSON.stringify({
    index: index.toJSON(),
    urlToDoc: urlToDoc
  });
};
