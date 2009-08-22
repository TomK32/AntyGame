class AnthillsController < ApplicationController
  before_filter :login_required

  make_resourceful do
    actions :all
    before :create do
      current_object.user_id = current_user.id
      current_object.map = Map.open.find(params[:anthill][:map_id])
    end
  end

end
