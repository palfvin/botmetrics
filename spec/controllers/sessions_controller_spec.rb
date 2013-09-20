require 'spec_helper'

describe SessionsController do

  describe "POST #create" do
    context "with a user not on the white list" do
      it "redirects to the root page with a warning and doesn't establisht the session" do
        user = FactoryGirl.create(:user, email: 'otheruser@gmail.com')
        User.should_receive(:from_omniauth).and_return(user)
        post :create
        session[:user_id].should be_nil
        response.should redirect_to root_path
      end
    end

    # context 'with a user on the white list' do
    #   it 'creates a session and redirects to the root page with a success message' do
    #     user = FactoryGirl.create(:user, email: "palfvin@gmail.com")
    #     User.should_receive(:from_omniauth).and_return(user)
    #     post :create
    #     session[:user_id].should == user.id
    #     response.should redirect_to root_path
    #   end
    # end
  end

end
