# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem

  # render new.rhtml
  def new
  end

  def create
    logout_keeping_session!
    
    if using_open_id?
      open_id_authentication(params[:openid_identifier] || params[:openid_url])
    else
      password_authentication(params[:name], params[:password])
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
  
  def open_id_authentication(identity_url)
    authenticate_with_open_id(identity_url, :required => %w(nickname email),
        :optional => 'fullname') do |result, identity_url, registration|
      if result.successful?
        session[:identity_url] = identity_url
        if @user = User.find_or_initialize_by_identity_url(identity_url)
          if @user.new_record?
            logger.debug("creating new user '%s'" % registration["nickname"])
            @user.login = registration["nickname"]
            @user.email = registration["email"]
            @user.name = registration["fullname"]
            @user.password = @user.password_confirmation = (1..20).map{ rand(9).to_s}.join.to_i.to_s(36)
            unless @user.save
              # not enough data from the provider. e.g. missing email or nickname
              render :template => 'users/new' and return
            end
          end
          self.current_user = @user
          successful_login
        else
          failed_login "Sorry, no user by that identity URL exists (#{identity_url})"
        end
      else
        failed_login result.message
      end
    end
  end
  def password_authentication
    user = User.authenticate(params[:login], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      redirect_back_or_default('/')
      flash[:notice] = "Logged in successfully"
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end
  private
  
    def successful_login
      session[:user_id] = @current_user.id
      redirect_to(root_url)
    end

    def failed_login(message)
      flash[:error] = message
      redirect_to(new_session_url)
    end
end
