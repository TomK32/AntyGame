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
    errors.add(I18n.t(:'ants.errors.tasks_unbalanced')) if (self.food + self.building + self.nursing) != 100
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
  
  def cycle
    # increase infrastructure first.
    # the bigger and strong ants you have the more tunnels you dig,
    # thus more space for food and nursing

    all_worker_skills = {}
    self.workers.each{|worker| worker.skills.each { |skill, value|
          all_worker_skills[skill] += value * worker.count } }

    self.building_count += (max(0,all_worker_skills[:strength]) + max(0,all_worker_skills[:size])) / (2.0 * self.building / 100)


    # increase food.
    # The faster and stronger the more food we'll get
    self.food_stock += (max(0,all_worker_skills[:strength]) + max(0,all_worker_skills[:speed])) / (2.0 * self.food / 100)

    # now, nursing is a bit more complicated.
    # the more fertile your queens the more baby ants we _could_ have
    # but the bigger and faster our workers the more will actually be born
    # also we need enough food and space
    self.max_nursing = (self.building_count + self.food_stock) / (self.ants.count / 2)

    new_ants = []
    self.queens.each do
      next if new_ants.sum(&:count) > self.max_nursing
      # TODO complete it
#      new_worker = Worker.new(:count => )
    end
  end
end
