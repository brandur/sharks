Highcharts.theme = 
  chart:
    backgroundColor: '#000'
  credits:
    enabled: false
  legend:
    enabled: false
  plotOptions:
    pie:
      dataLabels:
        color: '#fff'
  title:
    style:
      color: '#fff'
  tooltip:
    backgroundColor: 'rgba(255, 255, 255, .65)'
    borderWidth: 0
    borderRadius: 0
    shadow: false
  yAxis:
    gridLineColor: 'rgba(255, 255, 255, .1)'

# Apply the theme
highchartsOptions = Highcharts.setOptions(Highcharts.theme);
