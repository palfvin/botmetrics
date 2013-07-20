include ApplicationHelper

def sign_in(user)
  visit signin_path
  fill_in "Name", with: user.name
  fill_in "Email", with: user.uid
  click_button "Sign In"
end

def base_data_sample
 {title: 'Title', data: [[2], [3]], javascript: '{"series":[{"name":3,"data":[]}],"xAxis":{"categories":[]},"title":{"text":"Title"}}'}
end

def text_area_adjustment(string)
  "\n#{string}"
end

# def json_cleansed(object)
#   JSON.dump(JSON.parse(JSON.dump(object)))
# end

def google_data_source
  base_data_sample.merge({data_source: 'Google(testkey)', key: 'testkey'})
end

def mock_google_spreadsheet(data_source)
  spreadsheet = double('GoogleSpreadsheet')
  GoogleSpreadsheet.should_receive(:new).with(data_source[:key]).and_return(spreadsheet)
  spreadsheet.should_receive(:rows).and_return(data_source[:data])
  spreadsheet.should_receive(:title).and_return(data_source[:title])
end
