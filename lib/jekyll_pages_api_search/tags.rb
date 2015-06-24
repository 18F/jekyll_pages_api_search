# @author Mike Bland (michael.bland@gsa.gov)

require 'liquid'

module JekyllPagesApiSearch
  class SearchInterfaceTag < Liquid::Tag
    NAME = 'jekyll_pages_api_search_interface'
    Liquid::Template.register_tag(NAME, self)
    CODE = File.read(File.join(File.dirname(__FILE__), 'search.html'))

    def render(context)
      CODE
    end
  end

  class LoadSearchTag < Liquid::Tag
    NAME = 'jekyll_pages_api_search_load'
    Liquid::Template.register_tag(NAME, self)

    def render(context)
      return @code if @code
      baseurl = context.registers[:site].config['baseurl']
      @code = LoadSearchTag.generate_script baseurl
    end

    def self.generate_script(baseurl)
      "<script>SEARCH_BASEURL = '#{baseurl}';</script>\n" +
        "<script async src=\"#{baseurl}/assets/js/search-bundle.js\">" +
        "</script>"
    end
  end
end
