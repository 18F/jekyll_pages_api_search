# @author Mike Bland (michael.bland@gsa.gov)

require 'jekyll/static_file'

module JekyllPagesApiSearch
  class JavascriptCopier
    def self.copy_to_site(site)
      assets_path = File.join('assets', 'js')
      source = File.realpath(File.join(File.dirname(__FILE__), '..', '..'))
      begin_path = source.size + File::SEPARATOR.size
      Dir[File.join(source, assets_path, '**', '*')].each do |f|
        next unless File.file? f and f.end_with? '.min.js'
        f = f[begin_path..-1]
        site.static_files << ::Jekyll::StaticFile.new(
          site, source, File.dirname(f), File.basename(f))
      end
    end
  end
end
