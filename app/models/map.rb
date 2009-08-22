class Map < ActiveRecord::Base
  has_many :items
  has_many :stones
  has_many :foods
  has_many :anthills

  validates_presence_of :name, :width, :height
  validates_uniqueness_of :name
  validates_numericality_of :width, :height, :only_integer => true


  include AASM
  aasm_column :state
  aasm_initial_state :open
  aasm_state :open
  aasm_state :active
  aasm_state :inactive


  after_create :generate

  def generate
    position = {:longitude => 0, :latitude => 0}
    
    while !(position[:latitude] > height) and !(position[:longitude] > width) do
      position[:longitude] += rand((height + width) / 2)
      if position[:longitude] > width
        position[:longitude] -= width
        position[:latitude] += 1
      end
      case position[:longitude] % 10
        when 0..5
          items << Stone.new(position)
        else
          items << Food.new(position.merge(:count => rand(20) + 5))
      end
    end
  end
  private
  class Position < Hash
    attr_accessor :longitude, :latitude
  end
end
