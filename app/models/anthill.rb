class Anthill < ActiveRecord::Base
  belongs_to :user
  belongs_to :babysitter, :class_name => "User"

  has_one :queen
  has_one :item
end
