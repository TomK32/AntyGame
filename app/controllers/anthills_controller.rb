class AnthillsController < ApplicationController
  before_filter :login_required

  make_resourceful do
    actions :all
    before :create do
      current_object.user_id = current_user.id
      current_object.map = Map.open.find(params[:anthill][:map_id])
    end
    response_for :update_fails do |format|
      format.html do
        if params[:return_to] == 'show'
          render :action => 'show'
        else
          render :action => 'edit'
        end
      end
      format.json { render :json => false.to_json, :status => 422 }
    end
  end


  def cycle
    logger.debug current_object.cycle
    render :action => 'show' and return
  end
end
