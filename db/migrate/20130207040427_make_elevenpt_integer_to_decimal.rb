class MakeElevenptIntegerToDecimal < ActiveRecord::Migration
  def change
  	remove_column :gwas, :elevenpt
  	add_column :gwas, :final, :decimal, :precision => 10, :scale => 5
  end
end
