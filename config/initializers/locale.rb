# tell the I18n library where to find the translations
I18n.load_path += Dir[Rails.root.join("config", "locales", "*.{rb,yml}")]
 
# set default locale to :en
I18n.default_locale = :en