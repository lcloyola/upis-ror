class AddRoleToUserAndUserIdToFaculty < ActiveRecord::Migration
  def change
    add_column :users, :role, :integer, :default => 3
    add_column :faculties, :user_id, :integer

    add_index :faculties, :user_id
  end
end

