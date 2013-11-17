#= require application
#= require map


$ = jQuery

$ ->

  # Load data from html div's data
  js_data = $('#js-data')

  remainingTime = $('#remaining-time')
  remainingM100 = $('#remaining-m-100')
  remainingM0 = $('#remaining-m')
  remainingPercentage = $('#remaining-m-percentage')

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
          options:{icon: map.iconMarkerGenerator('markerActual', 35, 35)}
        })

        map.reloadMapWithNewMarkers({
          container: $('#map_canvas'),
          markers: markers,
          autofit: true
        })

      remainingM = result.remaining_m

      remainingTime.text(result.remaining_time)
      remainingM100.css('width', "#{100 - remainingM}%")
      remainingM0.css('width', "#{remainingM}%")
      remainingPercentage.text("#{remainingM}%")

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
    options:{icon: map.iconMarkerGenerator('markerA', 28, 37)}
  })

  bLat = js_data.data('blat')
  bLng = js_data.data('blng')

  markers.push({
    latLng: [bLat, bLng],
    options:{icon: map.iconMarkerGenerator('markerB', 28, 37)}
  })

  actualLat = js_data.data('actuallat')
  actualLng = js_data.data('actuallng')

  markers.push({
    latLng: [actualLat, actualLng],
    options:{icon: map.iconMarkerGenerator('markerActual', 28, 37)}
  })

  map.reloadMapWithNewMarkers({
    container: $('#map_canvas'),
    markers: markers,
    autofit: true
  })

  updateActualPosition(markers)
