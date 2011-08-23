$ ->
  $.get '/incidents/globe.json', 
    #(data) ->
    (incidents) ->
      globe = new DAT.Globe($("#globe")[0])
      #incidents = []
      #for incident in data
      #  continue if incident.lat == null
      #  incidents = incidents.concat [
      #    incident.lat, incident.lng, if incident.is_fatal then 0.7 else 0.1
      #  ]
      globe.addData(incidents, {format: 'magnitude'});
      globe.createPoints()
      globe.animate()
