class Anthill < ActiveRecord::Base

  attr_accessible :name, :food, :building, :nursing

  belongs_to :user
  belongs_to :babysitter, :class_name => "User"
  belongs_to :map

  validates_presence_of :name
  validates_presence_of :latitude, :longitude

  has_many :queens
  has_many :ants
  has_many :workers
  has_many :soldiers
  has_one :item
  
  before_validation_on_create :set_position
  before_validation_on_create :set_tasks
  after_create :create_item

  def validate
    errors.add(t(:'.tasks_unbalanced')) if (self.food + self.building + self.nursing) != 100
  end

  def set_position
    # place the anthill randomly
    # TODO keep some space to neighbouring hills
    
    self.latitude = rand(self.map.width)
    self.longitude = rand(self.map.height)
  end
  
  def set_tasks
    self.food = self.building = 30
    self.nursing = 40
  end

  def create_item
    AnthillItem.create(:anthill => self, :map => self.map, :latitude => latitude, :longitude => longitude)
  end
end
