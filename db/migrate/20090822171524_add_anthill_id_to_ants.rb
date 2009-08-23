class AddAnthillIdToAnts < ActiveRecord::Migration
  def self.up
    add_column :ants, :anthill_id, :integer, :null => false
  end

  def self.down
    remove_column :ants, :anthill_id
  end
end
