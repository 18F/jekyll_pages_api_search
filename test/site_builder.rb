# @author Mike Bland (michael.bland@gsa.gov)

require 'test_temp_file_helper'

module JekyllPagesApiSearch
  class SiteBuilder
    __TEMP_FILE_HELPER = TestTempFileHelper::TempFileHelper.new
    SOURCE_DIR = File.join(File.dirname(__FILE__), 'test-site')
    BUILD_DIR = __TEMP_FILE_HELPER.mkdir('test-site')
    puts "Building site in #{BUILD_DIR}"
    unless system(
      "cd #{SOURCE_DIR} && bundle exec jekyll build " +
        "--destination #{BUILD_DIR} --trace",
      {:out => '/dev/null', :err =>STDERR})
      STDERR.puts "\n***\nSiteBuilder failed to build site for tests\n***\n"
      exit $?.exitstatus
    end
  end
end
