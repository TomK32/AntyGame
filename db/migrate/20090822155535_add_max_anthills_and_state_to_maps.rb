class AddMaxAnthillsAndStateToMaps < ActiveRecord::Migration
  def self.up
    add_column :maps, :max_anthills, :integer, :default => 5, :null => false
    add_column :maps, :state, :string, :default => 'open'
    change_column :maps, :width, :integer, :default => 120
    change_column :maps, :height, :integer, :default => 80
  end

  def self.down
    remove_column :maps, :state
    remove_column :maps, :max_anthills
  end
end
