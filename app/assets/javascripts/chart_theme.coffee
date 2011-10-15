fontFamily = "'Helvetica Neue', Helvetica, Arial, sans-serif"
lightColor = '#666'

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
      color: lightColor
      fontFamily: fontFamily
      fontSize: '12px'
  title:
    style:
      color: '#fff'
      fontFamily: fontFamily
  tooltip:
    backgroundColor: '#000'
    borderColor: '#fff'
    borderWidth: 1
    borderRadius: 0
    shadow: false
    style:
      color: '#fff'
      fontFamily: fontFamily
      fontSize: '12px'
  xAxis:
    labels:
      style:
        color: lightColor
        fontFamily: fontFamily
  yAxis:
    gridLineColor: 'rgba(255, 255, 255, .1)'
    labels:
      style:
        color: lightColor
        fontFamily: fontFamily

# Apply the theme
highchartsOptions = Highcharts.setOptions(Highcharts.theme);
