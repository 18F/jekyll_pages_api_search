# @author Mike Bland (michael.bland@gsa.gov)

require_relative 'sass'
require_relative 'tags'

require 'fileutils'

module JekyllPagesApiSearch
  class Assets
    def self.write_to_files(baseurl, scss, html, js)
      [scss, html, js].each {|i| FileUtils.mkdir_p File.dirname(i)}
      FileUtils.cp Sass::INTERFACE_FILE, scss
      File.open(html, 'w') {|f| f << SearchInterfaceTag::CODE}
      File.open(js, 'w') {|f| f << LoadSearchTag::generate_script(baseurl)}
    end
  end
end
