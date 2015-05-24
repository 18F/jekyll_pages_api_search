# @author Mike Bland (michael.bland@gsa.gov)

require_relative 'js_copier'

require 'jekyll/site'
require 'jekyll_pages_api'
require 'zlib'

# This Jekyl::Site override creates a hook for generating the search index
# after the jekyll_pages_api plugin has produced the api/v1/pages.json corpus.
# In the very near term, we should probably create a proper hook in the
# jekyll_pages_api plugin itself.
module Jekyll
  class Site
    alias_method :pages_api_after_render, :after_render
    alias_method :orig_write, :write

    def skip_index?
      search_config = self.config['jekyll_pages_api_search']
      search_config == nil || search_config['skip_index']
    end

    def after_render
      pages_api_after_render
      return if skip_index?
      self.pages << JekyllPagesApiSearch::SearchIndexBuilder.build_index(self)
      JekyllPagesApiSearch::JavascriptCopier.copy_to_site(self)
    end

    def write
      orig_write
      pages_api_search_after_write unless skip_index?
    end

    def pages_api_search_after_write
      index = find_search_index_page
      raise 'Search index not found' if index == nil
      compressed = "#{index.destination self.dest}.gz"
      Zlib::GzipWriter.open(compressed, Zlib::BEST_COMPRESSION) do |gz|
        gz.write index.output
      end
    end

    def find_search_index_page
      pages.each {|p| return p if p.name == 'search-index.json'}
    end
  end
end
