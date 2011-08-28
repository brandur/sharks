$ ->
  $.get '/incidents/by_year.json', 
    (data) ->
      chart = new Highcharts.Chart 
        chart:
          backgroundColor: '#000'
          defaultSeriesType: 'line'
          renderTo: 'incidents_by_year'
        series: [
          {
            name: 'Attacks'
            data: data.map((y) -> y.count)
          }
        ]
        title:
          text: 'Attacks by year'
        tooltip:
          formatter: ->
            "#{this.y} #{if this.y != 1 then 'attacks' else 'attack'} in #{this.x}"
        xAxis:
          categories: data.map((y) -> y.year)
          labels:
            rotation: -45,
            align: 'right', 
        yAxis:
          min: 0,
          title:
            text: null
