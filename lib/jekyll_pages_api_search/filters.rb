# @author Mike Bland (michael.bland@gsa.gov)

require 'jekyll-assets'
require 'liquid/template'

module JekyllPagesApiSearch
  module Filters
    # Retrieves the asset_path for a search component.
    # This is to make the path compatible with require.js.
    def require_js_asset_path(path)
      # Digging into the jekyll-assets internals here, since we can't invoke
      # the Filter directly. https://github.com/jekyll/jekyll-help/issues/97
      r = ::Jekyll::AssetsPlugin::Renderer.new @context, path
      path = r.render_asset_path
      path.end_with? '.js' and path[0..-('.js'.length + 1)] or path
    end
  end
end

Liquid::Template.register_filter(JekyllPagesApiSearch::Filters)
