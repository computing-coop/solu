class FixNodes < Mongoid::Migration
  def self.up
    hms = Node.find 'hybrid-matters' 
    Subsite.all.each do |p|
      p.node = hms
      p.save
    end
    Activity.all.each do |p|
      p.node = hms
      p.save
    end
  end

  def self.down
  end
end