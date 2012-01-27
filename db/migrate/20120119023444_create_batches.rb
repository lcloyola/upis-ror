class CreateBatches < ActiveRecord::Migration
  def change
    create_table :batches do |t|
      t.integer :year
      t.string :remarks

      t.timestamps
    end
  end
end
