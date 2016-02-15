/* jshint node: true */

var gulp = require('gulp');
var yargs = require('yargs');
var mocha = require('gulp-mocha');
var eslint = require('gulp-eslint');

function buildArgs(args) {
  var argName, skipArgs = { _: true, '$0': true };

  for (argName in yargs.argv) {
    if (yargs.argv.hasOwnProperty(argName) && !skipArgs[argName]) {
      args[argName] = yargs.argv[argName];
    }
  }
  return args;
}

gulp.task('test', function() {
  return gulp.src(['./test/*.js'], {read: false});
});

gulp.task('lint', function() {
  return gulp.src(
    [ 'assets/js/search.js',
      'lib/jekyll_pages_api_search/search.js',
      'test/**/*.js',
    ])
    .pipe(eslint())
    .pipe(eslint.format());
});
