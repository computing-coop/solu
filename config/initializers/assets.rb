# Be sure to restart your server when you modify this file.
require "font-awesome-rails"
# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( ckeditor/* backoffice.js backoffice.css invitations.css investigations.css exhibitions.css)
Rails.application.config.assets.precompile += %w( bioart/stylesheets/backoffice.css  bioart/javascripts/backoffice.js  hybrid_matters/javascripts/backoffice.js hybrid_matters/stylesheets/backoffice.css)
Rails.application.config.assets.precompile += %w( video-js.swf vjs.eot vjs.svg vjs.ttf vjs.woff )