class MapsController < ApplicationController
  before_filter :login_required

  make_resourceful do
    actions :index, :new
  end

  def create
    @map = Map.create(params[:map])

    if @map.save
      redirect_to maps_url
    else
      render :action => 'new'
    end
  end
end
