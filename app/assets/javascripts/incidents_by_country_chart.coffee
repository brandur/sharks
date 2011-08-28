$ ->
  $.get '/incidents/by_country.json', 
    (data) ->
      current_year = new Date().getFullYear()
      current_year_data = data[current_year]
      chart = new Highcharts.Chart 
        chart:
          backgroundColor: '#000'
          defaultSeriesType: 'bar'
          renderTo: 'incidents_by_country'
        credits:
          enabled: false
        legend:
          enabled: false
        series: [
          {
            name: 'Attacks'
            data: current_year_data.map((y) -> y.count)
          }
        ]
        title:
          text: "Attacks in #{current_year}"
        tooltip:
          backgroundColor: 'rgba(255, 255, 255, .65)'
          borderWidth: 0
          borderRadius: 0
          formatter: ->
            "#{this.y} #{if this.y != 1 then 'attacks' else 'attack'} in #{this.x}"
          shadow: false
        xAxis:
          categories: current_year_data.map((y) -> y.country)
        yAxis:
          min: 0,
          title:
            text: null
