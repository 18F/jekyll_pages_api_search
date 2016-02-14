module JekyllPagesApiSearch
  class Config
    def self.skip_index?(site)
      search_config = site.config['jekyll_pages_api_search']
      search_config.nil? || search_config['skip_index']
    end
  end
end
