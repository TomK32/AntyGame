class CreateActions < ActiveRecord::Migration
  def self.up
    create_table :actions do |t|
      t.references :item, :null => false
      t.references :map
      t.references :babysitter

      t.string :state, :null => false, :default => 'active'

      t.integer :latitude
      t.integer :longitude

      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :actions
  end
end
