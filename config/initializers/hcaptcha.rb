Hcaptcha.configure do |config|
  config.site_key = Figaro.env.hcaptcha_public
  config.secret_key = Figaro.env.hcaptcha_private
end
