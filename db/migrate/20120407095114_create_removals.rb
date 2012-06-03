class CreateRemovals < ActiveRecord::Migration
  def change
    create_table :removals do |t|
      t.references :course
      t.references :student
      t.boolean :pass

      t.timestamps
    end
    add_index :removals, :course_id
    add_index :removals, :student_id
  end
end
