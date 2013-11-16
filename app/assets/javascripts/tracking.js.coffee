#= require application
#= require gmap3.min

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
