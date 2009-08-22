class AntsController < ApplicationController
  before_filter :login_required
  make_resourceful do
    actions :all
    belongs_to :anthill
  end
end
