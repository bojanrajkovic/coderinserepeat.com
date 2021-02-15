require "jekyll"

REGEX = /\[recipe: (.*)\]/

def fix_document_links(document, recipes)
    source_recipe_name = document.data['name']
    fix_string_links(source_recipe_name, document.content, recipes)

    document.data['ingredients'].each { |ingredient|
        if ingredient.match? REGEX then
            fix_string_links(source_recipe_name, ingredient, recipes)
        end
    }
end

def fix_string_links(source_recipe_name, content, recipes)
    target_recipe_name = content.match(REGEX)[1]
    Jekyll.logger.debug("Found recipe #{source_recipe_name} that contains link to another recipe, #{target_recipe_name}")

    target_recipe = recipes.docs.select { |doc| 
        doc.data['name'] == target_recipe_name
    }.first

    if !target_recipe then
        Jekyll.logger.warn("Recipe #{source_recipe_name} has invalid reference to recipe #{target_recipe_name}!")
        return
    end

    liquid_link_tag = "[#{target_recipe_name}]({% link #{target_recipe.relative_path} %})"

    content.gsub!(REGEX, liquid_link_tag)
end

Jekyll::Hooks.register(:documents, :pre_render) do |document|
    next unless document.collection.label == "recipes" and document.content.match? REGEX
    recipes = document.collection
    fix_document_links(document, recipes)
end