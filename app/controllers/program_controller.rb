class ProgramController < ApplicationController
  
  def index
    ongoing = Project.ongoing.published.order(year_range: :asc)
    old = Project.older.published
    @highlights = [ongoing, old.sort_by{|x| x.year_range.split('-').last.to_i}.reverse].flatten
    @activities = Activity.by_node(@node.id).published.asc(:start_at)
    set_meta_tags title: 'Program'
  end


end