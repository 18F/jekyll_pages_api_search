var requirejs_config = null;

var requirejs = require = function(deps, unused_callback, unused_errback,
  unused_optional) {
  requirejs_config = (!isArray(deps) && typeof deps !== 'string') ? deps : {};
};

requirejs.config = function(c) { return requirejs_config = c; };
