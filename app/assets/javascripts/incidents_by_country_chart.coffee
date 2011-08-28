$ ->
  $.get '/incidents/by_country.json', 
    (data) ->
      current_year = new Date().getFullYear()
      current_year_data = data[current_year]
      chart = new Highcharts.Chart 
        chart:
          defaultSeriesType: 'bar'
          renderTo: 'incidents_by_country'
        series: [
          {
            name: 'Attacks'
            data: current_year_data.map((y) -> y.count)
          }
        ]
        title:
          text: "Attacks in #{current_year}"
        tooltip:
          formatter: ->
            "#{this.y} #{if this.y != 1 then 'attacks' else 'attack'} in #{this.x}"
        xAxis:
          categories: current_year_data.map((y) -> y.country)
        yAxis:
          min: 0,
          title:
            text: null
