Rails.application.config.middleware.use OmniAuth::Strategies::OpenID, :store => OpenID::Store::ActiveRecord.new
