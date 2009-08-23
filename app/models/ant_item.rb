class AntItem < Item
  has_one :child, :class_name => 'Item'
end
