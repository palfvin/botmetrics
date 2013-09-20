class ApplicationController < ActionController::Base
  include SessionsHelper
  protect_from_forgery

private

 def require_authentication
    unless current_user
      flash[:error] = "You must be logged in to access this section"
      redirect_to root_path # halts request cycle
    end
  end
  helper_method :require_authentication

  def require_admin
    unless Rails.env.development? && current_user.uid == 'admin'
       flash[:error] = "Admin privileges required for that function"
       redirect_to root_path
     end
  end
  helper_method :require_admin

end
