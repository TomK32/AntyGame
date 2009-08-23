class AntItem < Item
  has_one :child, :class_name => 'Item', :foreign_key => 'item_id'
end
