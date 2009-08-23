class MapsController < ApplicationController
  skip_before_filter :login_required, :only => [:show, :index]

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

  def show
    @map = Map.find(params[:id])
    @items = @map.items.to_json(:only => [:longitude, :latitude, :type])
  end
end
