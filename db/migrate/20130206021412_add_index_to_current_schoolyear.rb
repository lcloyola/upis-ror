class AddIndexToCurrentSchoolyear < ActiveRecord::Migration
  def change
  	add_index :schoolyears, :current
  end
end
