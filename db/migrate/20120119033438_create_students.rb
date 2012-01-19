class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.integer :student_no
      t.references :batch
      t.string :last
      t.string :given
      t.string :middle
      t.string :nick
      t.text :address
      t.date :birthday
      t.string :mobile
      t.string :landline
      t.string :email
      t.string :religion
      t.string :entry
      t.boolean :graduate
      t.boolean :upcat
      t.boolean :disciplinary
      t.string :father
      t.string :foccupation
      t.string :foffice
      t.string :fcontact
      t.string :mother
      t.string :moccupation
      t.string :moffice
      t.string :mcontact
      t.string :guardian
      t.string :relationship
      t.string :gaddress
      t.string :gcontact

      t.timestamps
    end
    add_index :students, :batch_id
  end
end
