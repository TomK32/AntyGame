class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.references :map
      t.references :user
      t.references :ant
      t.references :anthill

      t.integer :longitude, :null => false
      t.integer :latitude, :null => false

      t.integer :count

      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
