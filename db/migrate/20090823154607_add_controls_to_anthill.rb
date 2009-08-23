class AddControlsToAnthill < ActiveRecord::Migration
  def self.up
    add_column :anthills, :food, :integer, :size => 4, :null => false
    add_column :anthills, :nursing, :integer, :size => 4, :null => false
    add_column :anthills, :building, :integer, :size => 4, :null => false

    add_column :anthills, :food_stock, :integer, :default => 0, :null => false
    add_column :anthills, :building_count, :integer, :default => 0, :null => false
    add_column :anthills, :max_nursing, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column :anthills, :max_nursing
    remove_column :anthills, :building_count
    remove_column :anthills, :food_stock

    remove_column :anthills, :nursing
    remove_column :anthills, :building
    remove_column :anthills, :food
  end
end
