class AddNodesToExisting < Mongoid::Migration
  def self.up
    Node.find_or_create_by(name: 'hybrid_matters', description: 'HYBRID_MATTERs', subdomains: 'hybridmatters')
    Node.find_or_create_by(name: 'bioart', description: 'Finnish Society of Bioart', subdomains: 'bioartsociety')
    hms = Node.find 'hybrid-matters' 
    Post.where(node: nil).each do |p|
      p.node = hms
      p.save
    end
    Page.where(node: nil).all.each do |p|
      p.node = hms
      p.save
    end
    Activity.where(node: nil).all.each do |p|
      p.node = hms
      p.save
    end
    Call.where(node: nil).all.each do |c|
      c.node = hms
      c.save
    end
    Event.where(node: nil).all.each do |e|
      e.node = hms
      e.save
    end
    Partner.where(node: nil).all.each do |p|
      p.node = hms
      p.save
    end
    Background.where(node: nil).all.each do |b|
      b.node = hms
      b.save
    end
    
  end

  def self.down
  end
end