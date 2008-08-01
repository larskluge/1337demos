# MultipleLayouts

# Support a clean separation between multiple layouts
#

module ActionView::Helpers::AssetTagHelper

	# path to layout helper
	# path bases on active layout

	def path_to_layout
		['/', controller.active_layout].join
	end



	# rewrite standard javascript|stylesheet|image path to active layout path

	alias :true_path_to_javascript :path_to_javascript
	def path_to_javascript(source)
		true_path_to_javascript(path_to_res('javascripts', source))
	end

	alias :true_path_to_stylesheet :path_to_stylesheet
	def path_to_stylesheet(source)
		true_path_to_stylesheet(path_to_res('stylesheets', source))
	end

	alias :true_path_to_image :path_to_image
	def path_to_image(source)
		true_path_to_image(path_to_res('images', source))
	end



	# rewrite stylesheet_link_tag to make it work with :cache-option

	alias :true_stylesheet_link_tag :stylesheet_link_tag

	def stylesheet_link_tag(*sources)
		options = sources.extract_options!.stringify_keys
        cache   = options.delete("cache")

		if cache && ActionController::Base.perform_caching
			joined_stylesheet_name = (cache == true ? "all" : cache) + ".css"
			joined_stylesheet_path = File.join [Rails.public_path, path_to_stylesheets(joined_stylesheet_name)]

			write_asset_file_contents(joined_stylesheet_path, my_compute_stylesheet_paths(sources))

			sources = joined_stylesheet_name

			#Rails.logger.info "Stylesheet files merged to: #{joined_stylesheet_name}"
		end

		true_stylesheet_link_tag(sources)
	end



	# rewrite javascript_include_tag to make it work with :cache-option

	alias :true_javascript_include_tag :javascript_include_tag

	def javascript_include_tag(*sources)
		options = sources.extract_options!.stringify_keys
        cache   = options.delete("cache")

		if cache && ActionController::Base.perform_caching
			joined_javascript_name = (cache == true ? "all" : cache) + ".js"
			joined_javascript_path = File.join [Rails.public_path, path_to_javascripts(joined_javascript_name)]

			write_asset_file_contents(joined_javascript_path, my_compute_javascript_paths(sources))

			sources = joined_javascript_name

			#Rails.logger.info "Javascript files merged to: #{joined_javascript_name}"
		end

		true_javascript_include_tag(sources)
	end



	private

	def my_compute_stylesheet_paths(sources)
		sources.collect { |src| path_to_stylesheet(src) }
	end

	def my_compute_javascript_paths(sources)
		sources.collect { |src| path_to_javascript(src) }
	end



	def path_to_res(res, source)
		path = [path_to_layout]
		path << "/#{res}" unless source =~ /^\//
		path << "/#{source}"
		return path.join
	end

end

