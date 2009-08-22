class Item < ActiveRecord::Base
  belongs_to :map
  belongs_to :user
  belongs_to :ant
  belongs_to :anthill
end
