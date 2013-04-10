require 'highchart_options'

describe HighchartOptions do
  let(:sample_array) { # Taken from Highcharts documentation
    [[nil, 'Apples', 'Bananas', 'Oranges'],['Jane', 1, 0, 4], ['John', 5, 7, 3]] }

  before do
    @highchart_options = HighchartOptions.new(sample_array, { title: 'Fruit Consumption' })
  end

  subject @highchart_options

  it 'should create the expected options' do
    @highchart_options.make_hash.should == {
              chart: {
            type: 'column'
        },
        title: {
            text: 'Fruit Consumption'
        },
        xAxis: {
            categories: ['Apples', 'Bananas', 'Oranges'],
        },
        series: [{
            name: 'Jane',
            data: [1, 0, 4]
        }, {
            name: 'John',
            data: [5, 7, 3]
        }]
    }
  end

end

