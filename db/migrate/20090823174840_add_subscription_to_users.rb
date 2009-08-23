class AddSubscriptionToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :subscription_active, :boolean, :default => false
    add_column :users, :subscription_plan, :string
  end

  def self.down
    remove_column :users, :subscription_plan_id
    remove_column :users, :subscription_active
  end
end
