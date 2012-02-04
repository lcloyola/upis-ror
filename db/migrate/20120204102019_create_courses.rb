class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.references :subject
      t.references :faculty
      t.references :schoolyear
      t.integer :sem
      t.references :section

      t.timestamps
    end
    add_index :courses, :subject_id
    add_index :courses, :faculty_id
    add_index :courses, :schoolyear_id
    add_index :courses, :section_id
  end
end
