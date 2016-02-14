require_relative './config'

require 'jekyll'

module JekyllPagesApiSearch
  class Generator < ::Jekyll::Generator
    def generate(site)
      return if Config.skip_index?(site)
      JekyllPagesApiSearch::SearchPageLayouts.register(site)
      site.pages << JekyllPagesApiSearch::SearchPage.new(site)
    end
  end
end
