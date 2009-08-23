class UsersController < ApplicationController
  skip_before_filter :login_required, :only => :show
  
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem

  before_filter :set_user, :only => :show
  
  def show
  end

  # render new.rhtml
  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    logger.debug [@user.identity_url, session[:identity_url]]
    @user.crypted_password = "" if @user.identity_url == session[:identity_url]
    success = @user && @user.save
    if success && @user.errors.empty?
            # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end
  private
  def set_user
    @user = User.find_by_login(params[:id])
    @user ||= User.find(params[:id])
  end
end
