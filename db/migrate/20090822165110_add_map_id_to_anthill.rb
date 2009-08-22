class AddMapIdToAnthill < ActiveRecord::Migration
  def self.up
    add_column :anthills, :map_id, :integer, :null => false
  end

  def self.down
    remove_column :anthills, :map_id
  end
end
