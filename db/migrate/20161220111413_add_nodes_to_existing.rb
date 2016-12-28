class AddNodesToExisting < Mongoid::Migration
  def self.up
    Node.find_or_create_by(name: 'hybrid_matters', description: 'HYBRID_MATTERs', subdomains: 'hybridmatters')
    Node.find_or_create_by(name: 'bioart', description: 'Finnish Society of Bioart', subdomains: 'bioartsociety')
    hms = Node.find 'hybrid-matters' 
    Post.all.each do |p|
      p.node = hms
      p.save
    end
    Page.all.each do |p|
      p.node = hms
      p.save
    end
    Activity.all.each do |p|
      p.node = hms
      p.save
    end
    Call.all.each do |c|
      c.node = hms
      c.save
    end
    Event.all.each do |e|
      e.node = hms
      e.save
    end
    Partner.all.each do |p|
      p.node = hms
      p.save
    end
    Background.all.each do |b|
      b.node = hms
      b.save
    end
    
  end

  def self.down
  end
end