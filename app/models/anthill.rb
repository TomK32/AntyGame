class Anthill < ActiveRecord::Base

#  attr_accessible :name, :food, :building, :nursing

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
  after_create :create_item, :create_workers

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
    self.workers.each do |worker|
      worker.skills.each do |skill, value|
        all_worker_skills[skill] ||= 0
        all_worker_skills[skill] += value * worker.count
      end
      # while we are at it, why not kill some ants?
      worker.count -= worker.count * rand(worker.skills[:lifetime]) / worker.skills[:lifetime]
      worker.save
    end

    self.building_count += ([0,all_worker_skills[:strength]].max + [0,all_worker_skills[:size]].max) / ([self.building, 1].max / 100.to_f)


    # increase food.
    # The faster and stronger the more food we'll get
    self.food_stock += ([0,all_worker_skills[:strength]].max + [0,all_worker_skills[:speed]].max) / ([self.food, 1].max / 100.to_f)

    # now, nursing is a bit more complicated.
    # the more fertile your queens the more baby ants we _could_ have
    # but the bigger and faster our workers the more will actually be born
    # also we need enough food and space
    self.max_nursing = (self.building_count + self.food_stock) / (self.ants.count / 2)

    new_worker_sum = 0
    self.queens.each do |queen|
      next if new_worker_sum > self.max_nursing
      # TODO complete it
      logger.debug('fert: %s' % queen.skills[:fertility])
      logger.debug('size: %s' % all_worker_skills[:size])
      logger.debug('spee: %s' % all_worker_skills[:speed])
      logger.debug('q: %s' % all_worker_skills[:size])

      new_worker_count = queen.skills[:fertility] / [([0,all_worker_skills[:size]].max + [0,all_worker_skills[:speed]].max), 1].max
      new_worker_count = [new_worker_count, self.max_nursing - new_worker_sum].max
      new_workers = self.workers.new
      new_workers.count = new_worker_count
      new_workers.dna = queen.dna # mutation is done by Ant.do_evolve
      new_workers.save!
      new_worker_sum += new_worker_count
    end
    
    self.save
  end
end
