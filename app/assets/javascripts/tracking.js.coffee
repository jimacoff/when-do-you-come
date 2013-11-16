#= require application
#= require gmap3.min
#
$ = jQuery

$ ->

  # Initializing part
  #
  trackingForm = $('#tracking-form')
  map = $('#map')

  trackingForm.on('submit', (event) ->
    createRoute()

    return false
  )


  # Functioning part

  createRoute = () ->
    getLatLng(trackingForm.find('#b-position').val(), (bLatLng) ->
      if (!bLatLng)
        console.log('zla b-adresa')
        return

      bLat = bLatLng.ob
      bLng = bLatLng.pb

      getGeolocation((aLatLng) ->
        if (!aLatLng)
          console.log('nepovolil si lokalizovanie tvojej polohy')
          return

        aLat = aLatLng.ob
        aLng = aLatLng.pb


        getDistanceAndDuration(aLatLng, bLatLng, () ->

        )
      )


    )

    valuesToSubmit = ""

    $.ajax({
      url: '/tracking/init_route', # sumbits it to the given url of the form
      type: 'POST',
      data: valuesToSubmit,
    }).success((result) ->

    )


  getLatLng = (address, callback) ->
    map.gmap3({
      getlatlng:{
        address:  address,
        callback: (result) ->
          if (result)
            latLng = result[0].geometry.location
            callback(latLng)
          else
            callback(false)
      }
    })

  getGeolocation = (callback) ->
    map.gmap3({
      getgeoloc:{
        callback : (latLng) ->
          if (latLng)
            callback(latLng)
          else
            callback(false)
      }
    })

  getDistanceAndDuration = (aLatLng, bLatLng, callback) ->
    console.log(aLatLng, bLatLng)
    map.gmap3({
      getdistance:{
        options:{
          origins:[aLatLng],
          destinations:[bLatLng],
          travelMode: google.maps.TravelMode.DRIVING
        },
        callback: (results, status) ->
          html = ""
          if (results)
            distance = results.rows[0].elements[0].distance.value
            duration = results.rows[0].elements[0].duration.value
            console.log(distance)
            console.log(duration / 60)
          else
            console.log('error')

        }
    })




