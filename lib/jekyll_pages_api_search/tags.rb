# @author Mike Bland (michael.bland@gsa.gov)

require 'jekyll-assets'
require 'liquid/template'

module JekyllPagesApiSearch
  class SearchInterfaceTag < Liquid::Tag
    def render(context)
      File.read(File.join(File.dirname(__FILE__), 'search.html'))
    end
  end
end

module JekyllPagesApiSearch
  class LoadSearchTag < Liquid::Tag
    def render(context)
      baseurl = context.registers[:site].config['baseurl']
      r = ::Jekyll::AssetsPlugin::Renderer.new(context,
        'vendor/requirejs/require')
      ("<script async data-main=\"#{baseurl}/assets/js/main\" " +
       "src=\"#{r.render_asset_path}\"></script>")
    end
  end
end

Liquid::Template.register_tag('jekyll_pages_api_search_interface',
  JekyllPagesApiSearch::SearchInterfaceTag)
Liquid::Template.register_tag('jekyll_pages_api_search_load',
  JekyllPagesApiSearch::LoadSearchTag)
