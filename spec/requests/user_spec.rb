require 'spec_helper'

describe User do

  before do
    @user = User.new(name: "Example User")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:id) }

end