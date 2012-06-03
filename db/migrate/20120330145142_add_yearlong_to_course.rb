class AddYearlongToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :yearlong, :boolean, :default => true
  end
end
