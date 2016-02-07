# @author Mike Bland (michael.bland@gsa.gov)

require_relative 'test_helper'
require_relative 'site_builder'
require_relative '../lib/jekyll_pages_api_search/tags'

require 'json'
require 'liquid'
require 'minitest/autorun'

module JekyllPagesApiSearch
  class DummyJekyllSite
    attr_accessor :config
    def initialize
      @config = {}
    end
  end

  class DummyLiquidContext
    attr_accessor :registers
    def initialize
      @registers = {:site => DummyJekyllSite.new}
    end
  end

  class SearchTest < ::Minitest::Test
    def setup
      @index_page_path = File.join(SiteBuilder::BUILD_DIR, 'index.html')
      assert(File.exist?(@index_page_path), "index.html does not exist")
      @context = DummyLiquidContext.new
    end

    def test_index_built
      index_file = File.join(SiteBuilder::BUILD_DIR,
        SearchIndexBuilder::INDEX_FILE)
      assert(File.exist?(index_file), "Serialized search index doesn't exist")

      File.open(index_file, 'r') do |f|
        search_index = JSON.parse f.read, :max_nesting => 200
        refute_empty search_index

        index = search_index['index']
        refute_empty index
        refute_nil index['corpusTokens']
        refute_nil index['documentStore']
        refute_nil index['fields']
        refute_nil index['pipeline']
        refute_nil index['ref']
        refute_nil index['tokenStore']
        refute_nil index['version']

        url_to_doc = search_index['url_to_doc']
        refute_empty url_to_doc
        url_to_doc.each do |k,v|
          refute_nil v['url']
          refute_nil v['title']
          assert_equal k, v['url']
        end
      end
    end

    def test_skip_index_page_not_included
      index_file = File.join(SiteBuilder::BUILD_DIR,
        SearchIndexBuilder::INDEX_FILE)

      File.open(index_file, 'r') do |f|
        search_index = JSON.parse f.read, :max_nesting => 200
        assert_nil search_index['url_to_doc']['/about/']
      end
    end

    def get_tag(name)
      Liquid::Template.tags[name].parse(nil, nil, nil, {})
    end

    def test_interface_style_present
      css_path = File.join(SiteBuilder::BUILD_DIR, 'css', 'main.css')
      assert(File.exist?(css_path), "css/main.css does not exist")
      File.open(css_path, 'r') do |f|
        assert_includes(f.read, 'ul.searchresultspopup',
          'generated files do not contain interface style code')
      end
    end

    def test_interface_tag_replaced
      tag = get_tag SearchInterfaceTag::NAME
      File.open(@index_page_path, 'r') do |f|
        assert_includes(f.read, tag.render(@context),
          'generated files do not contain interface code')
      end
    end

    def test_load_tag_replaced
      tag = get_tag LoadSearchTag::NAME
      @context.registers[:site].config['baseurl'] = ''
      File.open(@index_page_path, 'r') do |f|
        assert_includes(f.read, tag.render(@context),
          'generated files do not contain script loading code')
      end
    end
  end
end
