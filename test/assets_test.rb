# @author Mike Bland (michael.bland@gsa.gov)

require_relative 'test_helper'
require_relative '../lib/jekyll_pages_api_search/assets'
require_relative '../lib/jekyll_pages_api_search/sass'
require_relative '../lib/jekyll_pages_api_search/tags'

require 'fileutils'
require 'minitest/autorun'
require 'tmpdir'

module JekyllPagesApiSearch
  class AssetsTest < ::Minitest::Test
    attr_reader :basedir

    def setup
      @basedir = Dir.mktmpdir
    end

    def teardown
      FileUtils.remove_entry(basedir)
    end

    def test_write_assets_to_files
      baseurl = '/foo'
      scss = File.join(basedir, 'interface.scss')
      html = File.join(basedir, 'interface.html')
      js = File.join(basedir, 'load-search.js')

      Assets.write_to_files(baseurl, scss, html, js)
      assert(File.exist?(scss))
      assert_equal File.read(Sass::INTERFACE_FILE), File.read(scss)
      assert(File.exist?(html))
      assert_equal SearchInterfaceTag::CODE, File.read(html)
      assert(File.exist?(js))
      assert_equal(LoadSearchTag.generate_script(baseurl), File.read(js))
    end
  end
end
