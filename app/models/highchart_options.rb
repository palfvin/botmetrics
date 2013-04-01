class HighchartOptions

  def initialize(rows, options = {})
    @rows = rows
    @options = options
  end

  def make_hash
      {
        chart: {
            type: @options[:chart_type]||'line'
        },
        title: {
            text: @options[:title]
        },
        xAxis: {
            categories: @rows[0][1..-1],
        },
        series: @rows[1..-1].collect {|row| {name: row[0], data: row[1..-1] } }
      }
  end

end
