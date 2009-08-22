class CreateAnts < ActiveRecord::Migration
  def self.up
    create_table :ants do |t|

      t.string :type
      t.integer :dna, :null => false, :limit => 8
      t.integer :count

      t.integer :longitude
      t.integer :latitude

      t.timestamps
    end
  end

  def self.down
    drop_table :ants
  end
end
