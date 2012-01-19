class CreateBatches < ActiveRecord::Migration
  def change
    create_table :batches do |t|
      t.integer :year
      t.integer :remarks

      t.timestamps
    end
  end
end
