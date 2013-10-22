class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :create

  EMAIL_WHITELIST = ['palfvin@gmail.com', 'ealfvin@gmail.com', 'walfvin@gmail.com', 'fkoenig@pacbell.net', 'ralfvin@gmail.com']

  def new
    redirect_to '/auth/developer'
  end

  def create
    user = User.from_omniauth(env['omniauth.auth'])
    if EMAIL_WHITELIST.include?(user.email)
      sign_in(user)
      redirect_to root_url, notice: "Signed in"
    else
      redirect_to root_url, notice: "Login restricted to testers at this point"
    end
  end

  def destroy
    sign_out
    redirect_to root_url, notice: 'Signed out!'
  end

end
