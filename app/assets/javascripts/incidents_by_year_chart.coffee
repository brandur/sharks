$ ->
  $.get '/incidents/by_year.json', 
    (data) ->
      chart = new Highcharts.Chart 
        chart:
          defaultSeriesType: 'line'
          renderTo: 'incidents_by_year'
        series: [
          {
            name: 'Incidents'
            data: data.map((y) -> y.count)
          }
        ]
        title:
          text: 'Incidents by year'
        tooltip:
          formatter: ->
            "#{this.y} #{if this.y != 1 then 'incidents' else 'incident'} in #{this.x}"
        xAxis:
          categories: data.map((y) -> y.year)
          labels:
            rotation: -45,
            align: 'right', 
        yAxis:
          min: 0,
          title:
            text: null
