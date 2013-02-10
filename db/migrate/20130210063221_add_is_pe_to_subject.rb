class AddIsPeToSubject < ActiveRecord::Migration
  def change
  	add_column :subjects, :is_pe, :boolean, :default => false
  end
end
