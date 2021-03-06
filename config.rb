# frozen_string_literal: true

###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
activate :automatic_image_sizes

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end

# Methods defined in the helpers block are available in templates
helpers do
  def title
    if current_page.data.title
      current_page.data.title + " - Jurriaan's Blog"
    else
      "Jurriaan's Blog"
    end
  end
end

activate :blog do |blog|
  blog.layout = :blog_layout
  # set options on blog
end

page '/feed.xml', layout: false
page '/sitemap.xml', layout: false
page '/robots.txt', layout: false

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'
set :markdown_engine, :kramdown
set :markdown, fenced_code_blocks: true, smartypants: true
activate :syntax, line_numbers: true

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  activate :asset_hash

  # Use relative URLs
  activate :relative_assets

  activate :automatic_alt_tags

  activate :gzip
  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end
