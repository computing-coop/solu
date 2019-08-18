namespace :solu do
  task update_logos: :environment do
    partners = Partner.where(:logo.ne => '', :logo.exists => true)
    partners.each do |partner|
      partner.remote_logo_url = partner.logo.url.gsub('development', 'production')
      partner.logo.recreate_versions!
    end
  end
end
