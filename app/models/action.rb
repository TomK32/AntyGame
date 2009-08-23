class Action < ActiveRecord::Base
  belongs_to :item
  belongs_to :map
  belongs_to :babysitter, :class_name => 'User'
end
