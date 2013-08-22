require 'spec_helper'

describe ChartsController do
	let(:user) {FactoryGirl.create(:user)}
	before {sign_in user}
	it {
		visit new_chart_path
		puts "controller = #{controller}, id = #{controller.object_id}"
		expect(true).to eql(true)}
end
