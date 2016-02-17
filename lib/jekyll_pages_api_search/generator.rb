require_relative './js_copier'
require_relative './config'

require 'jekyll'

module JekyllPagesApiSearch
  class Generator < ::Jekyll::Generator
    def generate(site)
      return if Config.skip_index?(site)
      JekyllPagesApiSearch::JavascriptCopier.copy_to_site(site)
    end
  end
end
