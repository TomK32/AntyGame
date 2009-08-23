class ActionsWorker < Workling::Base
  def process
    loop do
      Action.active.each do |action|
        # Destination reached?
        if action.latitude == action.item.latitude && action.longitude == action.item.longitude
          case action.type
            when 'CollectFoodAction':
              if food_item = FoodItem.find_by_latitude_and_longitude(action.item.latitude, action.item.longitude)
                # Remove count of ants food from food_item
                food_item.count = action.item.count > food_item.count ? 0 : food_item.count - action.item.count

                # Create food_item and attach it to ant
                FoodItem.create(:parent => action.item, :count => action.item.count)

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
        end
      end
      sleep 3
    end
  end
end
