require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/*test.rb']
end

desc "Run tests"
task :default => :test
task :test => :optimize_js

task :build => :compress_files

def program_exists?(program)
  system '/usr/bin/which', program, [:out,:err]=>'/dev/null'
end

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

desc "Optimize JavaScript components"
task :optimize_js => :check_for_node do
  abort unless system('uglifyjs', '-c', '-m',
    '-o', File.join(%w(lib jekyll_pages_api_search lunr.min.js)),
    '--', File.join(%w(assets js vendor lunr.js lunr.js)))
  abort unless system('r.js', '-o', 'build.js')
end

desc "Apply gzip compression to JavaScript files"
task :compress_files => :optimize_js do
  unless program_exists? 'gzip'
    puts "Cannot determine if the gzip program exists on the system; " +
      "skipping compression."
    return
  end

  Dir[File.join(%w(assets js ** *.min.js))].each do |f|
    unless system 'gzip', '--best', '-c', f, :out=>"#{f}.gz" 
      abort "compression failed for: #{f}"
    end
  end
end
