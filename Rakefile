require 'bundler/gem_tasks'
require 'rake/testtask'
require 'v8'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/*test.rb']
end

desc "Run tests"
task :default => :test

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
end

desc "Update JavaScript components"
task :update_js_components => :check_for_node do
  abort unless system 'npm', 'update'
  abort unless system 'bower', 'update'
end

LIB_LUNR_TARGET = File.join %w(lib jekyll_pages_api_search lunr.min.js)
LIB_LUNR_SOURCE = File.join %w(node_modules lunr lunr.min.js)

file LIB_LUNR_TARGET => LIB_LUNR_SOURCE do
  FileUtils.cp LIB_LUNR_SOURCE, LIB_LUNR_TARGET
end

# TODO(mbland): Extract this and other bits from this Rakefile into a gem.
cxt = V8::Context.new
basedir = File.dirname(__FILE__)
package_json = File.read File.join(basedir, 'package.json')
cxt.eval "var package = #{package_json};"
main_js = cxt[:package].main
search_bundle = File.join 'assets', 'js', 'search-bundle.js'

file search_bundle => main_js do
  unless system 'browserify', '-g', 'uglifyify', main_js, :out=>search_bundle
    abort "browserify failed"
  end
end

search_bundle_gz = "#{search_bundle}.gz"

file search_bundle_gz => search_bundle do
  unless program_exists? 'gzip'
    puts "Cannot determine if the gzip program exists on the system; " +
      "skipping compression."
    return
  end
  unless system 'gzip', '--best', '-c', search_bundle, :out=>search_bundle_gz
    abort "compression failed for: #{search_bundle}"
  end
end

task :build_js => [:check_for_node, LIB_LUNR_TARGET, search_bundle] do
end

task :test => :build_js

task :build => [
  :test,
  search_bundle_gz,
]
