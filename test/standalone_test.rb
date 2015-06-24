# @author Mike Bland (michael.bland@gsa.gov)

require_relative 'test_helper'
require_relative 'site_builder'
require_relative '../lib/jekyll_pages_api_search'

require 'digest'
require 'fileutils'
require 'jekyll_pages_api/generator'
require 'minitest/autorun'
require 'tmpdir'

module JekyllPagesApiSearch
  class DummySite
    def each_site_file
    end
  end

  class StandaloneTest < ::Minitest::Test
    attr_reader :basedir, :config, :pages_json_rel_path
    attr_reader :generated_pages_json, :search_bundle_path, :search_index_path
    attr_reader :orig_pages_json, :orig_search_bundle, :orig_search_index

    def setup
      @basedir = File.join Dir.mktmpdir
      FileUtils.cp_r SiteBuilder::BUILD_DIR, @basedir
      @config = File.join SiteBuilder::SOURCE_DIR, '_config.yml'

      # Just need this to grab the canonical JekyllPagesApi output path.
      generator = ::JekyllPagesApi::Generator.new DummySite.new
      page = generator.page
      @pages_json_rel_path = page.path
      @generated_pages_json = File.join @basedir, @pages_json_rel_path
      @search_bundle_path = File.join(@basedir, JavascriptCopier::ASSETS_DIR,
        'search-bundle.js')
      @search_index_path = File.join(@basedir, 'search-index.json')

      StandaloneTest.remove_files @search_bundle_path, @search_index_path

      @orig_pages_json = File.join SiteBuilder::BUILD_DIR, page.path
      @orig_search_bundle = File.join(SiteBuilder::BUILD_DIR,
        'search-bundle.js')
      @orig_search_index= File.join SiteBuilder::BUILD_DIR, 'search-index.json'
    end

    def self.remove_files(*files_to_remove)
      files_to_remove.each do |f|
        FileUtils.remove_file File.join(@basedir, f) if File.exist? f
        gz = "#{f}.gz"
        FileUtils.remove_file File.join(@basedir, gz) if File.exist? gz
      end
    end

    def teardown
      FileUtils.remove_entry self.basedir
    end

    def assert_file_exists_and_matches_original(generated_file, orig_file)
      assert File.exist?(generated_file), "#{generated_file} not generated"
      assert_equal(::Digest::SHA256.file(generated_file),
        ::Digest::SHA256.file(generated_file),
        "content of generated file #{generated_file}\n" +
        "differs from original  file #{orig_file}")
    end

    def test_create_index_and_pages_json
      StandaloneTest.remove_files self.pages_json_rel_path
      baseURL = ""
      title_prefix = ""
      body_element_tag = '<div class="wrapper">'
      Standalone::generate_index(self.basedir, self.config,
        self.generated_pages_json, baseURL, title_prefix, body_element_tag)

      assert_file_exists_and_matches_original(self.search_bundle_path,
        self.orig_search_bundle)
      assert_file_exists_and_matches_original("#{self.search_bundle_path}.gz",
        "#{self.orig_search_bundle}.gz")
      assert_file_exists_and_matches_original(self.search_index_path,
        self.orig_search_index)
      assert_file_exists_and_matches_original("#{self.search_index_path}.gz",
        "#{self.orig_search_index}.gz")
      assert_file_exists_and_matches_original(self.generated_pages_json,
        self.orig_pages_json)
      assert_file_exists_and_matches_original("#{self.generated_pages_json}.gz",
        "#{self.orig_pages_json}")
    end

    def test_create_index_using_existing_pages_json
      baseURL = nil
      title_prefix = nil
      body_element_tag = nil
      Standalone::generate_index(self.basedir, self.config,
        self.orig_pages_json, baseURL, title_prefix, body_element_tag)

      assert_file_exists_and_matches_original(self.search_bundle_path,
        self.orig_search_bundle)
      assert_file_exists_and_matches_original("#{self.search_bundle_path}.gz",
        "#{self.orig_search_bundle}.gz")
      assert_file_exists_and_matches_original(self.search_index_path,
        self.orig_search_index)
      assert_file_exists_and_matches_original("#{self.search_index_path}.gz",
        "#{self.orig_search_index}.gz")
      refute(File.exist?(self.generated_pages_json),
        "#{self.pages_json_rel_path} generated when it shouldn't've been")
      refute(File.exist?("#{self.generated_pages_json}.gz"),
        "#{self.pages_json_rel_path}.gz generated when it shouldn't've been")
    end
  end
end
