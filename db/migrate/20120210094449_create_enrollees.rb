class CreateEnrollees < ActiveRecord::Migration
  def change
    create_table :enrollees do |t|
      t.references :course
      t.references :student
      t.integer :quartera
      t.integer :quarterb

      t.timestamps
    end
    add_index :enrollees, :course_id
    add_index :enrollees, :student_id
    add_index :enrollees, [ :course_id, :student_id], :unique =>true
  end
end
