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
      index_file = File.join(SiteBuilder::BUILD_DIR, 'search-index.json')
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

    def test_interface_tag_replaced
      tag = Liquid::Template.tags[SearchInterfaceTag::NAME].new(nil, nil, nil)
      File.open(@index_page_path, 'r') do |f|
        assert_includes(f.read, tag.render(@context),
          'generated files do not contain interface code')
      end
    end

    def test_load_tag_replaced
      tag = Liquid::Template.tags[LoadSearchTag::NAME].new(nil, nil, nil)
      @context.registers[:site].config['baseurl'] = ''
      File.open(@index_page_path, 'r') do |f|
        assert_includes(f.read, tag.render(@context),
          'generated files do not contain script loading code')
      end
    end
  end
end
