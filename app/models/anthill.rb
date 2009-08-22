class Anthill < ActiveRecord::Base

  attr_accessible :name

  belongs_to :user
  belongs_to :babysitter, :class_name => "User"
  belongs_to :map

  validates_presence_of :name
  validates_presence_of :latitude, :longitude

  has_one :queen
  has_many :ants
  has_one :item
  
  before_validation_on_create :set_position

  def set_position
    # place the anthill randomly
    # TODO keep some space to neighbouring hills
    
    self.latitude = rand(self.map.width)
    self.longitude = rand(self.map.height)

    puts y self
  end
end
