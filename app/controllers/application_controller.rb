class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

private

 def require_authentication
   puts "checking current_user #{current_user}"
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
