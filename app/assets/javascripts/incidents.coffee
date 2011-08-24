$ ->
  $.get '/incidents/globe.json', 
    (incidents) ->
      globe = new DAT.Globe($("#globe")[0])
      globe.addData(incidents, {format: 'magnitude'});
      globe.createPoints()
      globe.animate()
