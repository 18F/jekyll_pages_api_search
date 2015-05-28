require.config({
  paths: {
    'jquery': 'vendor/jquery/jquery.min',
    'angular': 'vendor/angular/angular.min',
    'angularAMD': 'vendor/angularAMD/angularAMD.min',
    'liveSearch': 'vendor/angular-livesearch/liveSearch.min',
    'lunr': 'vendor/lunr.js/lunr.min'
  },
  shim: {
    'angular': ['jquery'],
    'angularAMD': ['angular'],
    'liveSearch': ['angular'],
    'lunr': []
  },
  deps: ['search.min']
});
