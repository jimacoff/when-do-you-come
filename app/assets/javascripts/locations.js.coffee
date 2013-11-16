#= require application
#= require map


$ = jQuery

$ ->

  # Load data from html div's data
  js_data = $('#js-data')



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

  map.reloadMapWithNewMarkers({
    container: $('#map_canvas'),
    markers: markers,
    autofit: true
  })

