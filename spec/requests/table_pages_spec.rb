require 'spec_helper'

describe "tables page" do

  before do
    @user = FactoryGirl.create(:user)
    @table = FactoryGirl.create(:table, user: @user, name: 'Table 1', data: [[1,2,3]])
    sign_in @user
  end

  subject { page }

  it "for index list the names of the user's tables" do
    visit tables_user_path(@user)
    page.should have_content('Table 1')
  end

  it "for show displays the table name and HTML table contents" do
    visit table_path(@table)
    page.should have_content('Table 1')
  end

  it "for edit displays the name field" do
    visit edit_table_path(@table)
    page.should have_field('Name')
  end

  describe "for create" do
    before do
      visit new_table_path
    end

    it "displays the name field on the create page" do
      visit new_table_path
      page.should have_field('Name')
    end

    context "creating new table" do

      let (:click) {click_button 'Create my table'}

      subject { page }

      before do
        fill_in "Name", with: base_data_sample[:title]
      end

      it "should create table" do
        fill_in 'table_data', with: base_data_sample[:data]
        click
        should have_link(base_data_sample[:title])
      end

      it "should pull data from Google when data is empty" do
        mock_google_spreadsheet(google_data_source)
        fill_in 'table_data_source', with: google_data_source[:data_source]
        click
        should have_content('Table created')
      end

      it "should not pull data from Google when data_source and data are both present" do
        other_sample_table_data = '[[1,2]]'
        GoogleSpreadsheet.should_receive(:new).exactly(0).times
        fill_in 'table_data_source', with: google_data_source[:data_source]
        fill_in 'table_data', with: other_sample_table_data
        click
        should have_content('Table created')
      end

    end

  end

end


