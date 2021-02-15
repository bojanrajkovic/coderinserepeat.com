---
title: Including collections in Jekyll archives
date: 2020-04-05 11:42:47 -0400
tags:
  - Programming
  - Jekyll
  - Ruby
categories:
  - Software Engineering
---

Recently, I decided to upload all my recipes onto my blog, as a convenient way
to share them, any modifications I made, and the original source. It also
allows me to have a "backup" of them, as the [tool that I wrote][exporter]
also exports [Paprika's][paprika] "importable" format (really just gzip +
JSON).

The best way to do this was as a Jekyll collection, which lets me neatly keep
them separate from the actual blog posts. However, I wanted my recipe
categories to be used by `jekyll-archives` as part of tag
generation. Normally, this is not supported, but Ruby monkey-patching allows
me to commit the following crime in a Jekyll plugin (appropriately called
`fixup-recipe-tags.rb`):

{% highlight ruby %}
{% raw %}
require "jekyll-archives"
require "jekyll"

module Jekyll
    module Archives
        class Archives
            alias_method :old_tags, :tags

            def collection_tags(collection_name)
                hash = Hash.new { |h, key| h[key] = [] }
                @site.collections[collection_name].docs.each do |p|
                    p.data["tags"]&.each { |t| hash[t] << p }
                end
                hash.each_value { |posts| posts.sort! }
                hash
            end

            def tags
                collections_to_tag = @config['collections']

                merged_tags = @site.post_attr_hash("tags")
                collections_to_tag.each { |collection|
                    merged_tags = merged_tags.merge(collection_tags(collection)) { |key, v1, v2| [v1,v2].flatten }
                }
                merged_tags
            end
        end
    end
end
{% endraw %}
{% endhighlight %}

It's probably not idiomatic Ruby, but it allows me to add the following to the
`jekyll-archives` section of `_config.yml`:

{% highlight yaml %}
collections:
  - recipes
{% endhighlight %}

With that, the recipes are used for _tags_, but they're not emitted into the
category pages or date-based archives. They're also not emitted into my
"tagged" page, because that only works with the posts collection.

[exporter]: https://github.com/bojanrajkovic/paprika-exporter
[paprika]: https://paprikaapp.com