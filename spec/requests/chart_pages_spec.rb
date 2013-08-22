require 'spec_helper'

describe "chart pages" do

  let(:user) {FactoryGirl.create(:user)}
  let(:chart) {FactoryGirl.create(:chart, user: user, name: 'Chart 1')}

  before {sign_in user}

  subject { page }

  it "for show displays the chart name" do
    visit chart_path(chart)
    page.should have_content('Chart 1')
  end

  it "for show displays the edit link" do
    visit chart_path(chart)
    page.should have_link('Edit')
  end

  it "for show displays the delete link" do
    visit chart_path(chart)
    page.should have_link('Delete')
  end

  it "for edit displays the name field" do
    visit edit_chart_path(chart)
    page.should have_field('chart_name')
  end

  it "for create displays the name field" do
    visit new_chart_path
    page.should have_field('Name')
  end

  describe "for create" do

    it "should create a new chart" do
      visit new_chart_path
      fill_in 'Name', with: 'My Chart'
      click_button 'Create my chart'
      page.should have_content('Chart created')
    end

    describe "with a data_source" do

      shared_examples "a data_source" do |input = :data_source|
        it "creates a chart with a data_source" do
          visit new_chart_path
          fill_in 'chart_data_source', with: data_source[input]
          click_button 'Create my chart'
          click_link 'Edit'
          page.should have_field('chart_data_source', with: data_source[:data_source])
          page.should have_field('chart_javascript', with: text_area_adjustment(data_source[:javascript]))
        end
      end

      describe "Google case" do

        let(:data_source) {google_data_source}

        before {mock_google_spreadsheet(data_source)}

        describe "an explicity declared Google source" do
          it_behaves_like "a data_source"
        end

        describe "a implicit Google source" do
          it_behaves_like "a data_source", :key
        end

      end

      describe "Table case" do
        let(:table) {FactoryGirl.create(:table, data: base_data_sample[:data], name: base_data_sample[:title])}
        let(:data_source) {base_data_sample.merge({data_source: "Table(#{table.id})"})}

        it_behaves_like "a data_source"
      end

    end

  end

end


