require 'bundler/gem_tasks'
require 'rake/testtask'

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
  which = '/usr/bin/which'
  opts = {[:out,:err]=>'/dev/null'}

  unless system(which, 'which', opts)
    puts [
      "Cannot automatically check for Node.js and NPM packages on this system.",
      "If Node.js is not installed, visit https://nodejs.org/.",
      "If any of the following packages are not yet installed, please install",
      "them by executing `npm install -g PACKAGE`, where `PACKAGE` is one of",
      "the names below:"].join("\n")
    puts "  " + programs.join("\n  ")
    return
  end

  unless system(which, 'node', opts)
    abort 'Please install Node.js: https://nodejs.org/'
  end

  programs = [
    'bower',
    'bower-installer',
    ['uglify-js', 'uglifyjs'],
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
task :update_js => :check_for_node do
  abort unless system('bower', 'update')
  abort unless system('bower-installer')
end

desc "Compress JavaScript components"
task :compress_js => :check_for_node do
  Dir[File.join(File.dirname(__FILE__), 'assets', 'js', '**', '*')].each do |f|
    next unless File.file? f and f.end_with? '.js' and not f.end_with? '.min.js'
    outfile = "#{f[0..-('.js'.size + 1)]}.min.js"
    abort unless system('uglifyjs', '-c', '-m', '--', f, :out=>outfile)
  end
end
