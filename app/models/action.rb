class Action < ActiveRecord::Base
  belongs_to :item
  belongs_to :map
  belongs_to :babysitter, :class_name => 'User'

  include AASM

  aasm_column :state
  aasm_initial_state :active
  aasm_state :active
  aasm_state :finished

  aasm_event :finish do
    transitions :to => :finished, :from => [:active]
  end

  def self.inheritance_column
    nil
  end

  def self.process_active
    Action.active.each do |action|
      # Destination reached?
      if action.latitude == action.item.latitude && action.longitude == action.item.longitude
        case action.type
          when 'CollectFoodAction':
            if food = Food.find_by_longitude_and_latitude(action.item.longitude, action.item.latitude)
              # Remove count of ants food from food_item
              food.count = action.item.count > food.count ? 0 : food.count - action.item.count

              # Create food_item and attach it to ant
              Food.create(:parent => action.item, :count => action.item.count, :longitude => 0, :latitude => 0)

              # Mark action as finished
              action.finish

              # Create new action to return to anthill
              Action.create(:item => action.item,
                            :map => action.map,
                            :longitude => action.item.ant.anthill.item.longitude,
                            :latitude => action.item.ant.anthill.item.latitude,
                            :type => 'ReturnToAnthill')
            end
          when 'ReturnToAnthill':
            # Remove food_item from ant
            action.item.child.delete

            # Mark action as finished
            action.finsh
        end
      else
        # Move ant one unit towards destination
        longitude_delta = action.longitude - action.item.longitude
        latitude_delta = action.latitude - action.item.latitude

        if longitude_delta > latitude_delta
          action.item.longitude += (longitude_delta / longitude_delta.abs).round
          action.item.latitude += (latitude_delta / longitude_delta.abs).round
        else
          action.item.longitude += (longitude_delta / latitude_delta.abs).round
          action.item.latitude += (latitude_delta / latitude_delta.abs).round
        end

        action.item.save
      end
    end
  end
end
