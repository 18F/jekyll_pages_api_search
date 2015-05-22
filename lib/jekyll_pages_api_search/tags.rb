# @author Mike Bland (michael.bland@gsa.gov)

require 'liquid/template'

module JekyllPagesApiSearch
  class SearchInterfaceTag < Liquid::Tag
    def render(context)
      File.read(File.join(File.dirname(__FILE__), 'search.html'))
    end
  end

  class LoadSearchTag < Liquid::Tag
    def render(context)
      baseurl = context.registers[:site].config['baseurl']
      ("<script>SEARCH_BASEURL = '#{baseurl}';</script>\n" +
       "<script async data-main=\"#{baseurl}/assets/js/main.min\" " +
       "src=\"#{baseurl}/assets/js/vendor/requirejs/require.min.js\">" +
       "</script>")
    end
  end
end

Liquid::Template.register_tag('jekyll_pages_api_search_interface',
  JekyllPagesApiSearch::SearchInterfaceTag)
Liquid::Template.register_tag('jekyll_pages_api_search_load',
  JekyllPagesApiSearch::LoadSearchTag)
