class UpdateAllActivities < Mongoid::Migration
  def self.up
    Activity.scoped.update_all(published: true)
  end

  def self.down
  end
end