OmniAuth.logger.level = Logger::WARN

Rails.application.config.middleware.use OmniAuth::Builder do
  production = Rails.env.production?
  provider :developer unless production
  provider :facebook,
    ENV[production ? 'FACEBOOK_KEY' : 'FACEBOOK_LOCAL_KEY'],
    ENV[production ? 'FACEBOOK_SECRET' : 'FACEBOOK_LOCAL_SECRET']
end