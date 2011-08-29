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
        connectorColor: '#fff'
  subtitle:
    style:
      color: '#666'
  title:
    style:
      color: '#fff'
  tooltip:
    backgroundColor: '#000'
    borderColor: '#fff'
    borderWidth: 1
    borderRadius: 0
    shadow: false
    style:
      color: '#fff'
  yAxis:
    gridLineColor: 'rgba(255, 255, 255, .1)'

# Apply the theme
highchartsOptions = Highcharts.setOptions(Highcharts.theme);
