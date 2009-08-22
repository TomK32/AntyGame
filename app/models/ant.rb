class Ant < ActiveRecord::Base
  belongs_to :anthill

  has_one :item
end
