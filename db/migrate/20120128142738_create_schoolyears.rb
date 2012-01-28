class CreateSchoolyears < ActiveRecord::Migration
  def change
    create_table :schoolyears do |t|
      t.integer :start
      t.text :remarks
      t.boolean :current

      t.timestamps
    end
  end
end
