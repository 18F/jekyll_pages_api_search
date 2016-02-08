require 'bundler/gem_tasks'
require 'rake/testtask'
require 'v8'
require 'zlib'

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

desc "Install JavaScript components"
task :install_js_components => :check_for_node do
  abort unless system 'npm', 'install'
end

desc "Update JavaScript components"
task :update_js_components => :check_for_node do
  abort unless system 'npm', 'update'
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
  unless system 'npm', 'run', 'make-bundle'
    abort "browserify failed"
  end
end

search_bundle_gz = "#{search_bundle}.gz"
file search_bundle_gz => search_bundle do
  ::Zlib::GzipWriter.open(search_bundle_gz, ::Zlib::BEST_COMPRESSION) do |gz|
    gz.write(File.read(search_bundle))
  end
end

ARTIFACTS = [LIB_LUNR_TARGET, search_bundle, search_bundle_gz]

task :build_js => [ :check_for_node ].concat(ARTIFACTS) do
  ARTIFACTS.each do |artifact|
    unless File.exist?(artifact) && File.stat(artifact).size != 0
      abort "#{artifact} missing or empty"
    end
  end
end

task :clean do
  [search_bundle, search_bundle_gz].each { |f| File.unlink(f) }
end

task :test => [:build_js]
task :build => [:test]
task :ci_build => [:install_js_components, :test]
