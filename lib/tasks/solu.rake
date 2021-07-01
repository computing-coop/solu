namespace :solu do
  task migrate_projects: :environment do
    Activity.all.each do |a|
      a.projects << a.project
    end
    Page.all.each do |p|
      p.projects << p.project
    end
    Post.all.each do |p|
      p.projects << p.project
    end
    
  end

  task update_logos: :environment do
    partners = Partner.where(:logo.ne => '', :logo.exists => true)
    partners.each do |partner|
      partner.remote_logo_url = partner.logo.url.gsub('development', 'production')
      partner.logo.recreate_versions!
    end
  end
end
