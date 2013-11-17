#= require application
#= require gmap3.min
#
$ = jQuery

$ ->

  reloadingTime = 1

  bLatLng = {lat: bLat, lng: bLng}

  fakeData = [
    {lat: 48.17770520383635, lng: 17.061767578125}
    {lat: 48.28830451948713, lng: 17.010440826416016},
    {lat: 48.709314421349, lng: 16.98657989501953},
    {lat: 49.112618905453026, lng: 16.64999485015869},
    {lat: 49.26825260148869, lng: 17.009754180908203},
    {lat: 49.550161777111995, lng: 17.1881103515625},
    {lat: 49.83089628828897, lng: 18.217391967773438},
    {lat: 50.1962428134763, lng: 18.700103759765625},
    {lat: 50.13466432216696, lng: 19.46502685546875},
    {lat: 50.083582032198564, lng: 19.79736328125},
    {lat: 50.06465009999999, lng: 19.94497990000002}
  ]

  fakeIterator = 0

  if ($('.tracking-reload').length)
    remainingTime = $('#remaining-time')
    remainingM100 = $('#remaining-m-100')
    remainingM0 = $('#remaining-m')
    remainingPercentage = $('#remaining-m-percentage')

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
            remaining_time: duration,
            email: $('#mom_email').val()
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

        remainingM = result.remaining_m

        remainingTime.text(result.remaining_time)
        remainingM100.css('width', "#{100 - remainingM}%")
        remainingM0.css('width', "#{remainingM}%")
        remainingPercentage.text("#{remainingM}%")

      else if (result.status == "NOT OK")
        console.log('data has NOT been updated')

    )

  fakeDataForDemoDay = (bLatLng, positionId) ->
    aLatLng = fakeData[fakeIterator % fakeData.length]
    fakeIterator++
    aLat = aLatLng.lat
    aLng = aLatLng.lng

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
        fakeDataForDemoDay(bLatLng, positionId)
      , reloadingTime*1000)
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

    if ($('#demo-day').length)
      setTimeout(() ->
        fakeDataForDemoDay(bLatLng, positionId)
      , reloadingTime*1000)
    else
      setTimeout(() ->
        reloadGeolocation(bLatLng, positionId)
      , reloadingTime*1000)





