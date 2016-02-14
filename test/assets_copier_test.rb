# @author Mike Bland (michael.bland@gsa.gov)

require_relative 'test_helper'
require_relative '../lib/jekyll_pages_api_search/assets'

require 'fileutils'
require 'minitest/autorun'
require 'tmpdir'

module JekyllPagesApiSearch
  class DummySite
    attr_accessor :static_files

    def initialize
      @static_files = []
    end
  end

  class AssetsCopyToSiteTest < ::Minitest::Test
    def test_copy_to_site
      site = DummySite.new
      Assets::copy_to_site(site)
      bundle, bundle_gz = site.static_files
      refute_nil bundle
      refute_nil bundle_gz

      output_dir = File.join(Assets::SOURCE, Assets::JAVASCRIPT_DIR)
      assert_equal File.join(output_dir, 'search-bundle.js'), bundle.path
      assert_equal Assets::JAVASCRIPT_DIR, bundle.destination_rel_dir
      assert_equal File.join(output_dir, 'search-bundle.js.gz'), bundle_gz.path
      assert_equal Assets::JAVASCRIPT_DIR, bundle_gz.destination_rel_dir
    end
  end

  class AssetsCopyToBasedirTest < ::Minitest::Test
    attr_reader :basedir

    def setup
      @basedir = Dir.mktmpdir
    end

    def teardown
      FileUtils.remove_entry self.basedir
    end

    def test_copy_to_basedir
      Assets::copy_to_basedir(self.basedir)
      assets_dir = File.join(self.basedir, Assets::JAVASCRIPT_DIR)
      assert(Dir.exist?(assets_dir))
      expected = ['search-bundle.js', 'search-bundle.js.gz'].map do |f|
        File.join(assets_dir, f)
      end
      assert_equal(expected, Dir[File.join assets_dir, '*'])
    end
  end
end
