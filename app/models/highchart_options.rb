class HighchartOptions

  def initialize(rows, params = {})
    @rows = rows
    @params = params
    @params[:headers] = true unless @params.key?(:headers)
    @headers = @params[:headers]
  end

  def series
    start_index = @headers ? 1 : 0
    @rows[start_index..-1].each_with_index.collect do |row, index|
      {name: @headers ? row[0] : "Series #{index}" , data: row[start_index..-1] }
    end
  end

  def make_hash()
    hco = {
      chart: {
          type: @params[:chart_type]||'column'
      },
      title: {
          text: @params[:title]
      },
      series: series
    }
    hco.merge({xAxis: { categories: @rows[0][1..-1] }}) if @headers
  end

end
