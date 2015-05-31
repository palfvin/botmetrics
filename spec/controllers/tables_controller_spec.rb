describe TablesController do
  before {}
  describe '#new' do
    before { get :new }
    it 'assigns @table' do
      expect(assigns(:table)).to be_a_kind_of(Table)
    end
    it 'succeeds' do
      expect(response.status).to be(200)
    end
  end
end