class CreateAnthills < ActiveRecord::Migration
  def self.up
    create_table :anthills do |t|
      t.references :user, :null => false
      t.references :babysitter

      t.integer :longitude, :null => false
      t.integer :latitude, :null => false

      t.string :name, :null => false
      t.string :state, :null => 'false', :default => 'active'

      t.integer :worker_count, :null => false, :default => 0
      t.integer :soldier_count, :null => false, :default => 0

      t.datetime :last_action_at

      t.timestamps
    end
  end

  def self.down
    drop_table :anthills
  end
end
