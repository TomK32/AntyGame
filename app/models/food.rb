class Food < Item
  belongs_to :parent, :class_name => 'Item'
end
