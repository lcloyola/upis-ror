class AddIsLockedToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :is_locked, :integer, :default => 0
  end
end

