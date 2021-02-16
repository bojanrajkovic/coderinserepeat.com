require "jekyll-archives"
require "jekyll"

module Jekyll
  module Archives
    class Archives
      alias_method :old_generate, :generate

      def generate(site)
        @site = site
        @posts = site.posts

        # Filter out hidden posts from the document collection, before the archives are generated.
        @posts.docs = @posts.docs.select { |doc| doc.data["hidden"].nil? || doc.data["hidden"] == false }

        @archives = []

        @site.config["jekyll-archives"] = @config

        read
        @site.pages.concat(@archives)

        @site.config["archives"] = @archives
      end
    end
  end
end
