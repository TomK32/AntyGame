class Map < ActiveRecord::Base
  has_many :items
  has_many :anthills, :class_name => "anthill", :foreign_key => "reference_id"

  validates_presence_of :name, :width, :height
  validates_uniqueness_of :name
  validates_numericality_of :width, :height, :only_integer => true


  include AASM
  aasm_column :state
  aasm_initial_state :active
  aasm_state :active
  aasm_state :inactive

end
