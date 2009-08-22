class Map < ActiveRecord::Base
  has_many :items
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
    positions = {}

    # Create stones on 30-40% of the map
    (width * height * (0.3 + rand(0.1))).to_i.times do
      begin
        longitude, latitude = rand(width), rand(height)
      end while positions[longitude * latitude]

      items << Stone.new(:latitude => latitude, :longitude => longitude)
    end

    # Create 1-10 units of food on 10-20% of the map
    ((width * height * 0.1) + rand((width * height) * 0.1)).to_i.times do
      begin
        longitude, latitude = rand(width), rand(height)
      end while positions[longitude * latitude]

      items << Food.new(:latitude => latitude, :longitude => longitude, :count => rand(10) + 1)
    end
  end
end
