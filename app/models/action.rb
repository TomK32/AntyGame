class Action < ActiveRecord::Base
  belongs_to :item
  belongs_to :map
  belongs_to :babysitter, :class_name => 'User'

  include AASM

  aasm_column :state
  aasm_initial_state :active
  aasm_state :active
  aasm_state :finished

  aasm_event :finish do
    transitions :to => :finished, :from => [:active]
  end
end
