Recaptcha.configure do |config|
  config.public_key  = Figaro.env.recaptcha_public
  config.private_key = Figaro.env.recaptcha_private
end