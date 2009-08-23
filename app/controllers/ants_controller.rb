class AntsController < ApplicationController
  before_filter :login_required

  def singular?
    false
  end
  def current_model_name
    return sti_name ? sti_name.singularize.camelize : controller_name.singularize.camelize
  end
  
  # The name of the instance variable that load_object and load_objects should assign to.
  def instance_variable_name
    return controller_name if !sti_name
    return sti_name if !parent?
    if parent_object.respond_to?(sti_name.downcase.to_sym)
      return sti_name.downcase
    elsif parent_object.respond_to?(sti_name.downcase.pluralize.to_sym)
      return sti_name.downcase.pluralize
    end
    sti_name.downcase
  end

  def sti_name
    return @sti_name if @sti_name
    @sti_name = (params[:type] || params[:ant][:type])
    @sti_name = if @sti_name and Ant::AVAILABLE_TYPES.include?(@sti_name.camelize)
      @sti_name
    else
      false
    end
  end

  make_resourceful do
    actions :all
    belongs_to :anthill
    before :new, :create do
      logger.debug(current_object)
    end
    response_for :create do |format|
      format.html do
        redirect_to anthill_path(current_object.anthill)
      end
      format.json { render :json => true.to_json, :status => 200 }
    end
  end

end
