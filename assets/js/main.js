require.config({
  paths: {
    'angular': 'vendor/angular/angular.min',
    'angularAMD': 'vendor/angularAMD/angularAMD.min',
    'liveSearch': 'vendor/angular-livesearch/liveSearch.min',
    'lunr': 'vendor/lunr.js/lunr.min'
  },
  shim: {
    'angularAMD': ['angular'],
    'liveSearch': ['angular'],
    'lunr': []
  },
  deps: ['search.min']
});
