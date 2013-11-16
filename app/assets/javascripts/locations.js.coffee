#= require application
#= require map


$ = jQuery

$ ->

  # Load data from html div's data
  js_data = $('#js-data')

  refreshInterval = 10 # in seconds

  # Functions' stuff

  updateActualPosition = (markers) ->
    id = js_data.data('id')

    $.ajax({
      url: "/locations/#{id}/get_updated_position",
      type: 'GET'
    }).success((result) ->
      newActualLat = result.actualPosition.actual_poi_lat
      newActualLng = result.actualPosition.actual_poi_lng

      actualMarker = markers[2]

      if (newActualLat != actualMarker.latLng[0] or newActualLng != actualMarker.latLng[1])
        markers.pop()
        markers.push({
          latLng: [newActualLat, newActualLng],
          options:{icon: map.iconMarkerGenerator('b-marker', 35, 35)}
        })

        map.reloadMapWithNewMarkers({
          container: $('#map_canvas'),
          markers: markers,
          autofit: true
        })

      $('#remaining-time').text(result.remaining_time)
      $('#remaining-m-100').css('width', "#{100 - result.remaining_m}%")
      $('#remaining-m').css('width', "#{result.remaining_m}%")
      $('#remaining-m-percentage').text("#{result.remaining_m}%")

      setTimeout(() ->
        updateActualPosition(markers)
      , refreshInterval * 1000)




    )

  # Init stuff

  map = new Map()
  map.createBasicMap($('#map_canvas'), [48.12, 17.12], 15)


  aLat = js_data.data('alat')
  aLng = js_data.data('alng')

  markers = []

  markers.push({
    latLng: [aLat, aLng],
    options:{icon: map.iconMarkerGenerator('b-marker', 35, 35)}
  })

  bLat = js_data.data('blat')
  bLng = js_data.data('blng')

  markers.push({
    latLng: [bLat, bLng]
  })

  actualLat = js_data.data('actuallat')
  actualLng = js_data.data('actuallng')

  markers.push({
    latLng: [actualLat, actualLng],
    options:{icon: map.iconMarkerGenerator('b-marker', 35, 35)}
  })

  map.reloadMapWithNewMarkers({
    container: $('#map_canvas'),
    markers: markers,
    autofit: true
  })

  updateActualPosition(markers)
