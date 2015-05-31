def auth_mock
  OmniAuth.config.mock_auth[:facebook] = {
    'provider' => 'facebook',
    'uid' => '123545',
    'user_info' => {
      'name' => 'mockuser'
    },
    'credentials' => {
      'token' => 'mock_token',
      'secret' => 'mock_secret'
    }
  }
end

describe TablesController do
  # let(:auth_mock) { FactoryGirl.create(:user) }

  before do
    request.env['omniauth.auth'] = auth_mock
  end
  describe '#new' do
    it 'assigns @table' do
      get :new
      expect(assigns(:table)).to be_a_kind_of(Table)
    end
    it 'succeeds' do
      expect(response.status).to be(200)
    end
  end
end
