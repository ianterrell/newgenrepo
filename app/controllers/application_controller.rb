class ApplicationController < ActionController::Base
  protect_from_forgery

  
    ###
    ## Authentication
    #
  
    def current_user
      V1::User.from_omniauth(session[:omniauth_hash]) if session[:omniauth_hash]
    end
  
  
  ###
  ## Authorization
  #
  
  def current_user_role
    
      if user = current_user
        V1::User.role(user)
      else
        "Unauthenticated Default"
      end
    
  end
  
  def reject_as_unauthorized
    render :nothing => true, :status => :unauthorized
  end
end