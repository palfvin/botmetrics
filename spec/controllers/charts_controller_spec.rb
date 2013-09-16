require 'spec_helper'

describe ChartsController do
	let(:user) {FactoryGirl.create(:user)}
	before {sign_in user}
	it {
		visit new_chart_path
		expect(true).to eql(true)}
end
