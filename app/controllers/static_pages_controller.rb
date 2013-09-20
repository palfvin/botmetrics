class StaticPagesController < ApplicationController
  def about
  end

  def home
  	# binding.pry
    if current_user
      redirect_to charts_user_path(current_user)
    end
  end

  def help
  end
end
