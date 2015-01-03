require 'highchart_options'

describe HighchartOptions do
  let(:sample_array) { # Taken from Highcharts documentation
    [['Consumption(People \ Fruit)', 'Apples', 'Bananas', 'Oranges'],['Jane', 1, 0, 4], ['John', 5, 7, 3]] }

  before do
    @highchart_options = HighchartOptions.new('Fruit Consumption', sample_array, HashWithPathUpdate.new())
  end

  subject {@highchart_options}

  it 'should create the expected options' do
    expect(@highchart_options.options).to eq({
        title: {
            text: 'Fruit Consumption'
        },
        xAxis: {
            categories: ['Apples', 'Bananas', 'Oranges'],
            title: {text: 'Fruit'}
        },
        yAxis: {
          title: {text: 'Consumption'}
          },
        series: [{
            name: 'Jane',
            data: [1, 0, 4]
        }, {
            name: 'John',
            data: [5, 7, 3]
        }]
    })
  end

end

