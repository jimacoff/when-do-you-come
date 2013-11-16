#= require application
#= require gmap3.min
#
$ = jQuery

$ ->

  # Initializing part
  #
  trackingForm = $('#trackings-form')
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

      window.location = "/tracking/#{result.id}"

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




