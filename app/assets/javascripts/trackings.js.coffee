#= require application
#= require gmap3.min
#
$ = jQuery

$ ->

  reloadingTime = 10

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


        getDistanceAndDuration(aLatLng, bLatLng, (arrayOfDisAndDur) ->
          if (!arrayOfDisAndDur)
            console.log('neda sa najst vzdialenost a cas')
            return

          distance = arrayOfDisAndDur[0]
          duration = arrayOfDisAndDur[1]

          saveDataToDB({
            total_m: distance,
            remaining_m: distance,
            a_poi_lat: aLat,
            a_poi_lng: aLng,
            b_poi_lat: bLat,
            b_poi_lng: bLng,
            actual_poi_lat: aLat,
            actual_poi_lng: aLng,
            remaining_time: duration
          })

          )
        )
      )


  saveDataToDB = (dataAsObject) ->
    valuesToSubmit = $.param(dataAsObject)

    $.ajax({
      url: '/trackings/init_route', # sumbits it to the given url of the form
      type: 'POST',
      data: valuesToSubmit,
    }).success((result) ->

      window.location = "/trackings/"

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

            callback([distance, duration])
          else
            callback(false)

        }
    })

  updateReloadedDataToDB = (dataAsObject) ->
    valuesToSubmit = $.param(dataAsObject)

    $.ajax({
      url: '/trackings/update_position',
      type: 'POST',
      data: valuesToSubmit,
    }).success((result) ->

      if (result.status == 'OK')
        console.log('data has been updated')
      else if (result.status == "NOT OK")
        console.log('data has NOT been updated')

    )

  reloadGeolocation = (bLatLng, positionId) ->
    getGeolocation((aLatLng) ->
      if (!aLatLng)
        console.log('nepovolil si lokalizovanie tvojej polohy')
        return

      aLat = aLatLng.ob
      aLng = aLatLng.pb

      getDistanceAndDuration(aLatLng, bLatLng, (arrayOfDisAndDur) ->
        if (!arrayOfDisAndDur)
          console.log('neda sa najst vzdialenost a cas')
          return

        distance = arrayOfDisAndDur[0]
        duration = arrayOfDisAndDur[1]

        updateReloadedDataToDB({
          id: positionId,
          remaining_m: distance,
          actual_poi_lat: aLat,
          actual_poi_lng: aLng,
          remaining_time: duration
        })

        setTimeout(() ->
          reloadGeolocation(bLatLng, positionId)
        , reloadingTime*1000)
      )
    )

  # Initializing part

  trackingForm = $('#trackings-form')
  map = $('#map')

  # on index page
  if (trackingForm.length)
    trackingForm.on('submit', (event) ->
      createRoute()
      return false
    )

  # on tracking page
  if ($('.tracking-reload').length)
    jsData = $('#js-data')

    bLat = jsData.data('blat')
    bLng = jsData.data('blng')
    positionId = jsData.data('id')

    bLatLng = {lat: bLat, lng: bLng}


    setTimeout(() ->
      reloadGeolocation(bLatLng, positionId)
    , reloadingTime*1000)



