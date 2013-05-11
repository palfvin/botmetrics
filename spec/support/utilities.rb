include ApplicationHelper

def sign_in(user)
  visit signin_path
  fill_in "Name",    with: user.name
  fill_in "Email", with: user.uid
  click_button "Sign In"
end
