class SubscriptionsController < ApplicationController
  
  require 'spreedly'
  def show
    if params[:refresh] || (current_user.subscription_active? && current_user.updated_at < (Time.now() - 1.day))
      if spreedly_user = Spreedly::Subscriber.find(current_user.id)
        current_user.subscription_active = spreedly_user.active?
        current_user.subscription_plan = spreedly_user.feature_level
        current_user.save!
      end
    end
  end
  def destroy
    if current_user.subscription_active? == false
      flash[:notice] = t(:'subscriptions.not_subscribed')
    end
    if Spreedly::Subscriber.delete!(current_user.id)
      current_user.subscription_active = false
      current_user.save!
      flash[:notice] = t(:'subscriptions.subscription_canceled')
    end
    render :action => 'show' and return
  end
end
