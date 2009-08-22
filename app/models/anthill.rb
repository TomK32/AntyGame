class Anthill < ActiveRecord::Base
  belongs_to :user
  belongs_to :babysitter, :class_name => "User"

  validates_presence_of :name
  validates_presence_of :latititude, :longitude

  has_one :queen
  has_one :item
end
