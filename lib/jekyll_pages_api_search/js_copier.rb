# @author Mike Bland (michael.bland@gsa.gov)

require 'jekyll/static_file'

module JekyllPagesApiSearch
  class JavascriptCopier
    SOURCE = File.realpath(File.join(File.dirname(__FILE__), '..', '..'))
    ASSETS_DIR = File.join('assets', 'js')
    BEGIN_PATH = SOURCE.size + File::SEPARATOR.size

    def self.copy_to_site(site)
      self.search_bundle_paths do |f|
        site.static_files << ::Jekyll::StaticFile.new(
          site, SOURCE, File.dirname(f), File.basename(f))
      end
    end

    def self.search_bundle_paths
      Dir.glob(File.join(SOURCE, ASSETS_DIR, 'search-bundle.js*')) do |f|
        yield f[BEGIN_PATH..-1]
      end
    end
  end
end
