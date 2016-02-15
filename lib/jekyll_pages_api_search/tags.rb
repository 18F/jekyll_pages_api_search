# @author Mike Bland (michael.bland@gsa.gov)

require 'liquid'

module JekyllPagesApiSearch
  class SearchInterfaceTag < Liquid::Tag
    NAME = 'jekyll_pages_api_search_interface'.freeze
    Liquid::Template.register_tag(NAME, self)
    CODE = File.read(File.join(File.dirname(__FILE__), 'search.html'))
    TEMPLATE = Liquid::Template.parse(CODE)

    def render(context)
      site = context.registers[:site]
      baseurl = site.config['baseurl'] || ''
      search_endpoint = site.config['search_endpoint'] || 'search/'
      search_endpoint = "/#{baseurl}/#{search_endpoint}/".gsub('//', '/')
      TEMPLATE.render('search_endpoint' => search_endpoint)
    end
  end

  class LoadSearchTag < Liquid::Tag
    NAME = 'jekyll_pages_api_search_load'.freeze
    Liquid::Template.register_tag(NAME, self)

    def render(context)
      return @code if @code
      baseurl = context.registers[:site].config['baseurl']
      @code = LoadSearchTag.generate_script baseurl
    end

    def self.generate_script(baseurl)
      "<script>SEARCH_BASEURL = '#{baseurl}';</script>\n" \
        "<script async src=\"#{baseurl}/assets/js/search-bundle.js\">" \
        '</script>'
    end
  end

  class SearchResultsTag < Liquid::Tag
    NAME = 'jekyll_pages_api_search_results'.freeze
    Liquid::Template.register_tag(NAME, self)

    def render(_context)
      '<ol id=\'search-results\'></ol>'
    end
  end
end
