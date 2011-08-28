$ ->
  $.get '/incidents/by_age_group.json', 
    (age_group_data) ->
      $.get '/incidents/by_fatality.json', 
        (fatality_data) ->
          fatal     = fatality_data.fatal / fatality_data.total
          non_fatal = 1 - fatal
          $.get '/incidents/by_gender.json', 
            (gender_data) ->
              chart = new Highcharts.Chart 
                chart:
                  renderTo: 'incidents_by_demographic'
                  backgroundColor: '#000'
                credits:
                  enabled: false
                series: [
                  {
                    type: 'pie'
                    name: 'Attacks by fatality (last 10 years)'
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
                    name: 'Attacks by gender (last 10 years)'
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
                    name: 'Attacks by age group (last 10 years)'
                    innerSize: '55%'
                    data: for age_group, count of age_group_data
                      { name: age_group, y: count }
                    dataLabels:
                      enabled: true
                      color: '#fff'
                      connectorColor: '#fff'
                  }
                ]
                subtitle:
                  text: 'By age group, gender, and fatality over the last 10 years'
                tooltip:
                  backgroundColor: 'rgba(255, 255, 255, .65)'
                  borderWidth: 0
                  borderRadius: 0
                  formatter: ->
                    "<strong>#{this.point.name}</strong> #{this.y} #{if this.y != 1 then 'attacks' else 'attack'}"
                  shadow: false
                title:
                  text: 'Attacks by demographic'
