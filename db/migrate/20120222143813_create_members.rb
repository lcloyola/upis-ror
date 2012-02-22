class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.references :section
      t.references :student

      t.timestamps
    end
    add_index :members, :section_id
    add_index :members, :student_id
  end
end
