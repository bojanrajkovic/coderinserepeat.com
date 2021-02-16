require "yaml"
require "tzinfo"
require "slugify"

jekyll_conf_path = File.join(
  File.dirname(File.expand_path(__FILE__)),
  "_config.yml"
)
secrets_path = File.join(
  File.dirname(File.expand_path(__FILE__)),
  "secrets.yml"
)

secrets = YAML::safe_load(File.read(secrets_path))
jekyll_conf = YAML::safe_load(File.read(jekyll_conf_path), aliases: true)

namespace :generate do
  namespace :nav do
    desc "Generate navigation for recipe sidebar. Currently unused."
    task :recipes do
      root = File.dirname(File.expand_path(__FILE__))

      recipe_files = Dir[File.join(root, "_recipes", "*.md")]
      nav_file = File.join(root, "_data", "navigation.yml")

      existing_nav = YAML::safe_load(File.read(nav_file))
      existing_nav = {} if existing_nav.nil?

      recipes_nav = []

      recipe_files.each do |file|
        recipe = YAML::safe_load(File.read(file))

        if recipe.nil?
          puts "Could not load recipe from file #{file}"
          return
        end

        recipes_nav.append({
          "title" => recipe["name"],
          "url" => "/recipes/#{File.basename(file, ".md")}",
        })
      end

      existing_nav["recipes"] = recipes_nav.sort { |a, b| a["title"] <=> b["title"] }

      File.open(nav_file, "w") do |file|
        file.write(existing_nav.to_yaml)
      end
    end
  end

  namespace :posts do
    desc "Create a new post"
    task :new, [:title] do |t, args|
      jekyll_timezone = jekyll_conf["timezone"]
      tz = TZInfo::Timezone.get(jekyll_timezone)
      date = tz.utc_to_local(Time.now.utc)
      title = args[:title].slugify
      content = <<~HEREDOC
        ---
        title: #{args[:title]}
        date: #{date.to_s}
        tags: []
        categories: []
        published: false
        ---
      HEREDOC
      new_post = File.join(
        File.dirname(File.expand_path(__FILE__)),
        "_posts",
        "#{date.strftime("%Y-%m-%d")}-#{title}.md"
      )
      File.write(new_post, content)
      exec "sh -c 'exec \"$EDITOR\" \"$1\"' -- \"#{new_post}\""
    end
  end
end

desc "Deploy site to S3"
task :deploy do
  # Feed the GA tracking code into the config
  jekyll_conf["analytics"]["google"]["tracking_id"] = secrets["google_tracking_id"]
  File.open(jekyll_conf_path, "w") do |file|
    file.write(jekyll_conf.to_yaml)
  end

  system "JEKYLL_ENV=production bundle exec jekyll build"

  # Wipe it out again so we don't accidentally commit it
  jekyll_conf["analytics"]["google"]["tracking_id"] = ""
  File.open(jekyll_conf_path, "w") do |file|
    file.write(jekyll_conf.to_yaml)
  end

  system "aws s3 sync _site/ #{secrets["s3_bucket_url"]} --acl public-read --profile #{secrets["aws_profile_name"]}"
  system "aws cloudfront create-invalidation --distribution-id #{secrets["cloudfront_distribution_id"]}  --paths \"/*\" --profile #{secrets["aws_profile_name"]}"
end
