class CreateGwas < ActiveRecord::Migration
  def change
    create_table :gwas do |t|
      t.references :student
      t.references :schoolyear
      t.integer :gwa_type
      t.integer :raw
      t.integer :elevenpt

      t.timestamps
    end
    add_index :gwas, :student_id
    add_index :gwas, :schoolyear_id
  end
end
