$ ->
  $.get '/incidents/by_age_group.json', 
    (age_group_data) ->
      $.get '/incidents/by_fatality.json', 
        (fatality_data) ->
          $.get '/incidents/by_gender.json', 
            (gender_data) ->
              chart = new Highcharts.Chart 
                chart:
                  renderTo: 'incidents_by_demographic'
                series: [
                  {
                    type: 'pie'
                    name: 'Incidents by fatality (last 10 years)'
                    size: '35%',
                    innerSize: '25%'
                    data: [
                      { name: 'Fatal',     y: fatality_data.fatal, color: '#6A0603' }
                      { name: 'Non-fatal', y: fatality_data.total - fatality_data.fatal, color: '#056732' }
                    ]
                    dataLabels:
                      enabled: false
                  }, {
                    type: 'pie'
                    name: 'Incidents by gender (last 10 years)'
                    size: '45%',
                    innerSize: '35%'
                    data: [
                      { name: 'Male',   y: gender_data.male, color: '#2c6dfd' }
                      { name: 'Female', y: gender_data.female, color: '#e13179' }
                    ]
                    dataLabels:
                      enabled: false
                  }, {
                    type: 'pie'
                    name: 'Incidents by age group (last 10 years)'
                    innerSize: '55%'
                    data: for age_group, count of age_group_data
                      { name: age_group, y: count }
                    dataLabels:
                      enabled: true
                  }
                ]
                subtitle:
                  text: 'By age group, gender, and fatality over the last 10 years'
                tooltip:
                  formatter: ->
                    "<strong>#{this.point.name}</strong> #{this.y} #{if this.y != 1 then 'incidents' else 'incident'}"
                title:
                  text: 'Incidents by demographic'
