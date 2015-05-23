require.config({
  paths: {
    'jquery': 'vendor/jquery/jquery',
    'angular': 'vendor/angular/angular',
    'angularAMD': 'vendor/angularAMD/angularAMD',
    'liveSearch': 'vendor/angular-livesearch/liveSearch',
    'lunr': 'vendor/lunr.js/lunr',
    'requireLib': 'vendor/requirejs/require'
  },
  shim: {
    'angular': ['jquery'],
    'angularAMD': ['angular'],
    'liveSearch': ['angular'],
    'lunr': []
  },
  deps: ['search']
});
