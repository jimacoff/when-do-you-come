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
    getLatLng(trackingForm.find('#b-position').val(), (latLng) ->
      console.log(latLng)
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
            callback(0)
      }
    })



  $('#map').gmap3({
    getdistance:{
      options:{
        origins:["Zálesie, Slovakia"],
        destinations:["Bratislava, Slovakia"],
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
          html = "error"

        $("#distance").html( html )
      }
  })
