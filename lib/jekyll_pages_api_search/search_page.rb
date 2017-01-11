require 'jekyll'

module JekyllPagesApiSearch
  class SearchPage < ::Jekyll::Page
    DEFAULT_TITLE = 'Search results'
    DEFAULT_ENDPOINT = 'search'

    def initialize(site)
      search_config = site.config['jekyll_pages_api_search']
      dest_path = endpoint(site.config, search_config)

      super(site, File.dirname(__FILE__), '', dest_path)

      # TODO pull from
      # search_config['layout'] || SearchPageLayouts::DEFAULT_LAYOUT
      self.content = File.read(File.expand_path('../layouts/search-results.html', __FILE__))

      data['title'] = search_config['results_page_title'] || DEFAULT_TITLE
      data['layout'] = nil
      data['skip_index'] = true
    end

    # https://github.com/jekyll/jekyll-feed/blob/cf23f885bd6a4ef4e14cb90a28f8ff266989753e/lib/jekyll-feed/page-without-a-file.rb
    # https://github.com/jekyll/jekyll-sitemap/blob/10ce622b3b6de4300789d8efb864e40766387826/lib/jekyll/page_without_a_file.rb
    def read_yaml(*)
      @data ||= {}
    end

    private

    def endpoint(site_config, search_config)
      path = search_config['endpoint'] || DEFAULT_ENDPOINT
      "/#{path}/index.html".gsub(/\/+/, '/')
    end
  end
end
