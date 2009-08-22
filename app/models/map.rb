class Map < ActiveRecord::Base
  has_many :items

  validates_presence_of :name, :width, :height
  validates_uniqueness_of :name
  validates_numericality_of :width, :height, :only_integer => true
end
