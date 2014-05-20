class AddOrdinalityToSubject < ActiveRecord::Migration
  def change
    add_column :subjects, :ordinality, :integer, :default => 0
  end
end
