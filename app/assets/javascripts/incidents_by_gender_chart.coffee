$ ->
  $.get '/incidents/by_gender.json', 
    (data) ->
      chart = new Highcharts.Chart 
        chart:
          renderTo: 'incidents_by_gender'
          backgroundColor: '#000'
        credits:
          enabled: false
        series: [
          {
            type: 'pie'
            name: 'Last 100 years'
            size: '35%',
            innerSize: '25%'
            data: [
              { name: 'Male',   y: data.a100y.m.toFixed(2) * 100, color: '#053267' }
              { name: 'Female', y: data.a100y.f.toFixed(2) * 100, color: '#6A0603' }
            ]
            dataLabels:
              enabled: false
          }, {
            type: 'pie'
            name: 'Last 10 years'
            size: '45%',
            innerSize: '35%'
            data: [
              { name: 'Male',   y: data.a10y.m.toFixed(2) * 100, color: '#255287' }
              { name: 'Female', y: data.a10y.f.toFixed(2) * 100, color: '#8A2623' }
            ]
            dataLabels:
              enabled: false
          }, {
            type: 'pie'
            name: 'Last 1 year'
            innerSize: '55%'
            data: [
              { name: 'Male',   y: data.a1y.m.toFixed(2) * 100, color: '#4572A7' }
              { name: 'Female', y: data.a1y.f.toFixed(2) * 100, color: '#AA4643' }
            ]
            dataLabels:
              enabled: true
              color: '#fff'
              connectorColor: '#fff'
          }
        ]
        subtitle:
          text: 'Last 1, 10, & 100 years'
        tooltip:
          backgroundColor: 'rgba(255, 255, 255, .65)'
          borderWidth: 0
          borderRadius: 0
          formatter: ->
            "<strong>#{this.point.name}</strong> (#{this.series.name}) #{this.y}%"
          shadow: false
        title:
          text: 'Attacks by gender'
