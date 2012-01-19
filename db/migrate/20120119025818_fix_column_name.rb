class FixColumnName < ActiveRecord::Migration
  def up
    remove_column :batches, :remarks
    add_column :batches, :remarks, :string
  end

  def down
  end
end
