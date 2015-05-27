require 'bundler/gem_tasks'
require 'rake/testtask'
require 'v8'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/*test.rb']
end

desc "Run tests"
task :default => :test
task :test => :build

def program_exists?(program)
  system '/usr/bin/which', program, [:out,:err]=>'/dev/null'
end

desc "Check for Node.js and NPM packages"
task :check_for_node do
  unless program_exists? 'which'
    puts [
      "Cannot automatically check for Node.js and NPM packages on this system.",
      "If Node.js is not installed, visit https://nodejs.org/.",
      "If any of the following packages are not yet installed, please install",
      "them by executing `npm install -g PACKAGE`, where `PACKAGE` is one of",
      "the names below:"].join("\n")
    puts "  " + programs.join("\n  ")
    return
  end

  unless program_exists? 'node'
    abort 'Please install Node.js: https://nodejs.org/'
  end

  programs = [
    'bower',
    'bower-installer',
    ['uglify-js', 'uglifyjs'],
    ['requirejs', 'r.js'],
  ]
  programs.each do |npm|
    pkg, prog = npm
    prog = npm if prog == nil
    unless program_exists? prog
      abort "Please install #{pkg}: npm install -g #{pkg}"
    end
  end
end

desc "Update JavaScript components"
task :update_js_components => :check_for_node do
  abort unless system('bower', 'update')
  abort unless system('bower-installer')
end

LIB_LUNR_TARGET = File.join(%w(lib jekyll_pages_api_search lunr.min.js))
LIB_LUNR_SOURCE = File.join(%w(assets js vendor lunr.js lunr.js))

file LIB_LUNR_TARGET => LIB_LUNR_SOURCE do
  abort unless system('uglifyjs', '-c', '-m', '-o', LIB_LUNR_TARGET,
    '--', LIB_LUNR_SOURCE)
end

# The following parses the build.js used by the RequireJS package's r.js
# optimization tool. The `mainConfigFile` member from that file is parsed to
# discover all of the JavaScript files that the `out` member depends on.
# TODO(mbland): Extract this and other bits from this Rakefile into a gem.
cxt = V8::Context.new
build_js = nil
basedir = File.dirname(__FILE__)
File.open(File.join(basedir, 'build.js')) {|f| build_js = f.read}
cxt.eval "var build_js = #{build_js};"
config = cxt[:build_js].mainConfigFile
config_dir = File.dirname(config)
requirejs_outfile = cxt[:build_js].out
cxt.load File.join(basedir, 'require-shim.js')
cxt.load config
requirejs_paths = []
requirejs_config = cxt[:requirejs_config]
requirejs_config.paths.values.each {|i| requirejs_paths << i}
requirejs_config.deps.each {|i| requirejs_paths << i}
requirejs_paths = requirejs_paths.map {|i| "#{File.join config_dir, i}.js"}

file requirejs_outfile => requirejs_paths do
  abort unless system('r.js', '-o', 'build.js')
end

requirejs_outfile_gz = "#{requirejs_outfile}.gz"

file requirejs_outfile_gz => requirejs_outfile do
  unless program_exists? 'gzip'
    puts "Cannot determine if the gzip program exists on the system; " +
      "skipping compression."
    return
  end
  unless system('gzip', '--best', '-c', requirejs_outfile,
    :out=>requirejs_outfile_gz)
    abort "compression failed for: #{requrejs_outfile}"
  end
end

task :build => [
  :check_for_node,
  LIB_LUNR_TARGET,
  requirejs_outfile,
  requirejs_outfile_gz,
]
