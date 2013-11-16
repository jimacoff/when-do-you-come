#= require application
#= require gmap3.min

$('#map').gmap3({
  getroute:{
    options:{
      origin:"48 Pirrama Road, Pyrmont NSW",
      destination:"Bondi Beach, NSW",
      travelMode: google.maps.DirectionsTravelMode.DRIVING
    },
    callback: (results) ->
      if (!results)
        return

      $(this).gmap3({
        map:{
          options:{
            zoom: 13,
            center: [-33.879, 151.235]
          }
        },
        directionsrenderer:{
          options:{
            directions:results
          }
        }
      })
  }
})
