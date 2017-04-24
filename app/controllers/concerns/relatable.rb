module Relatable
  extend ActiveSupport::Concern
  
  def related_content
    related = []
    related += Post.tagged_with_any(self.tags_array)
    related += Page.tagged_with_any(self.tags_array)
    related += Activity.tagged_with_any(self.tags_array)
    related += Project.tagged_with_any(self.tags_array)
    if self.class == Activity
      unless self.activitytype.nil?
        related += self.activitytype.activities.delete_if{|x| x==self }
      end
    end
    related.compact.delete_if{|x| x == self}.delete_if{|x| x.node != self.node}.uniq
  end
  
end