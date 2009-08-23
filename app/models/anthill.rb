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
  
  before_validation_on_create :set_position, :set_tasks, :preset_anthill
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

  def preset_anthill
    self.food_stock = 20
    self.building_count = 20
  end
  
  def cycle
    # increase infrastructure first.
    # the bigger and strong ants you have the more tunnels you dig,
    # thus more space for food and nursing

    all_worker_skills = {}
    worker_count = 0
    tmp = {}
    self.workers.each do |worker|
      worker.skills.each do |skill, value|
        tmp[skill] ||= [0,0]
        tmp[skill][0] += value
        tmp[skill][1] += worker.count
      end
      tmp.each {|skill, pairs| all_worker_skills[skill] = pairs[0] / [pairs[1], 1].max }
      # while we are at it, why not kill some ants?
      worker.count -= 1 +(worker.count * 
        rand(worker.skills[:lifetime]) / (worker.skills[:lifetime] * 2))
      worker_count += worker.count
      worker.save
    end
    
    self.building_count += ([all_worker_skills[:strength] + all_worker_skills[:size], 1].max) * (worker_count * self.building / 100.0)
    logger.debug( 'grown in size by %i' % (self.building_count - self.building_count_was))


    # increase food.
    # The faster and stronger the more food we'll get
    self.food_stock += (self.building / 20.0) + ([all_worker_skills[:strength] + all_worker_skills[:speed], 1].max) * (worker_count * self.food / 100.0)
    logger.debug( 'increased food by %i' % (self.food_stock - self.food_stock_was))

    # now, nursing is a bit more complicated.
    # the more fertile your queens the more baby ants we _could_ have
    # but the bigger and faster our workers the more will actually be born
    # also we need enough food and space

    self.max_nursing = (self.building_count + self.food_stock) * (self.nursing / 100.0) * (worker_count / 2)
    logger.debug( 'max nursing is now %i bigger' % (self.max_nursing - self.max_nursing_was))

    new_worker_sum = 0
    self.queens.each do |queen|
      next if new_worker_sum > self.max_nursing or self.food_stock < 10
      # TODO complete it
      logger.debug('fert: %s' % queen.skills[:fertility])
      logger.debug('size: %s' % all_worker_skills[:size])
      logger.debug('spee: %s' % all_worker_skills[:speed])
      logger.debug('q: %s' % all_worker_skills[:size])

      new_worker_count = queen.skills[:fertility] / ([1,all_worker_skills[:size] + 1,all_worker_skills[:speed]].max).to_f
      new_worker_count = [new_worker_count, self.max_nursing - new_worker_sum].max
      new_worker_count = [new_worker_count, self.food_stock].min
      new_workers = self.workers.new
      new_workers.count = new_worker_count
      new_workers.dna = queen.dna # mutation is done by Ant.do_evolve
      new_workers.save!
      new_worker_sum += new_worker_count
      self.food_stock -= new_worker_count
    end
    self.food_stock -= worker_count

    if self.food_stock < 0
      self.food = 100
      self.nursing = self.building = 0
    end
    self.save and self.reload
  end
end
