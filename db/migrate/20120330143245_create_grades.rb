class CreateGrades < ActiveRecord::Migration
  def change
    create_table :grades do |t|
      t.references :course
      t.references :student
      t.integer :quarter
      t.integer :value

      t.timestamps
    end
    add_index :grades, :course_id
    add_index :grades, :student_id
  end
end
