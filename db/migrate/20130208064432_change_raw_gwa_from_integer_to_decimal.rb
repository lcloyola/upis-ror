class ChangeRawGwaFromIntegerToDecimal < ActiveRecord::Migration
  def change
  	remove_column :gwas, :raw
  	add_column :gwas, :raw, :decimal, :precision => 10, :scale => 5
  end
end
