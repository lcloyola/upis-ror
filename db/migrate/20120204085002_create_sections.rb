class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.references :schoolyear
      t.references :faculty
      t.references :batch
      t.integer :year
      t.string :name

      t.timestamps
    end
    add_index :sections, :schoolyear_id
    add_index :sections, :faculty_id
    add_index :sections, :batch_id
  end
end
