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
    expect(page).to have_content('Table 1')
  end

  it "for show displays the table name and HTML table contents" do
    visit table_path(@table)
    expect(page).to have_content('Table 1')
  end

  context "edit" do

    before {visit edit_table_path(@table)}

    it "displays the name field" do
      expect(page).to have_field('Name')
    end

    it "lets you change the data value" do
      fill_in "Data", with: "[[4, 5]]"
      click_on 'Save changes'
      @table.reload
      expect(@table.data).to eql([[4,5]])
    end

  end

  describe "for create" do
    before do
      visit new_table_path
    end

    it "displays the name field on the create page" do
      visit new_table_path
      expect(page).to have_field('Name')
    end

    context "creating new table" do

      let (:click) {click_button 'Create my table'}

      subject { page }

      before do
        fill_in "Name", with: base_data_sample[:title]
      end

      it "should create table" do
        fill_in 'table_data', with: base_data_sample[:data].to_s
        click
        should have_link(base_data_sample[:title])
      end

      it "should pull data from Google when data is empty" do
        mock_google_spreadsheet(google_data_source)
        fill_in 'table_data_source', with: google_data_source[:data_source]
        click
        should have_content('Table created')
      end

    end

  end

end


