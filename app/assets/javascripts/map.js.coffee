#= require gmap3.min

class Map
  """
  Initialize map with some options.
  map_canvas - jQuery object with selected div where map should reside
  center - [lat, lng]
  """
  constructor: () ->
    me = @
    me.icon_cache = {}
    #@map_canvas.gmap3({
      #map: {
        #options: {
          #center: center,
          #mapTypeId: google.maps.MapTypeId.ROADMAP,
          #zoom: 15,
          #streetViewControl: false
        #},
        #events: {

          #dragend: (map)->
            #bounds = map.getBounds()
            #northEast = bounds.getNorthEast()
            #southWest = bounds.getSouthWest()
            #zoomLevel = map.getZoom()

            #$.get('http://localhost:6543/get_data/markers',
                #'north_east': northEast.lat() + ',' + northEast.lng()
                #'south_west': southWest.lat() + ',' + southWest.lng()
                #'zoom_level': zoomLevel,
            #(markers) ->
              #me.reloadMapWithNewMarkers(markers.markers)
            #)
        #}
      #}
    #})

  getMarker: (container, marker_id, callback) ->
    container.gmap3({
      get: {
        id: marker_id,
        callback: (marker) ->
          callback(marker)
      }
    })

  createBasicMap: (container, center, zoom_level) ->
    container.gmap3({
      map: {
        options: {
          center: center,
          mapTypeId: google.maps.MapTypeId.ROADMAP,
          zoom: zoom_level
        }
      }
    })

  autofit: (container) ->
    container.gmap3("autofit")

  getOrCreatePropertyMap: (container, center, property) ->
    me = @

    if (me.property_map != undefined && me.property_map)
      return
    else
      me.property_map = true

    me.createBasicMap(container, center, 15)
    if (!$.isArray(property))
      property = [property]
    @_loadMarkers(container, property)


  _clearMarkersFromMap: (container, callback) ->
    container.gmap3({
      clear: {
        name: "marker",
        callback: ->
          if (callback)
            callback()
      }
    })

  addMarkersToMap: (markers) ->
    me = @
    me.map_canvas.gmap3({
      marker: {
        values: markers
      }
    })

  reloadMapWithNewMarkers: (params)->
    container = params.container
    markers = params.markers
    autofit = params.autofit
    events = params.events

    me = @
    me._clearMarkersFromMap(container, () ->
      setTimeout(() ->
        me._loadMarkers(container, markers, events)
        if (autofit)
          me.autofit(container)
      , 1)
    )

  _loadMarkers: (container, markers, events) ->
    container.gmap3({
      marker: {
        values: markers,
        events: events
      }
    })
    setTimeout(() ->
      map = container.gmap3('get')
      center = map.getCenter()
      google.maps.event.trigger(map, "resize")
      map.setCenter(center)
    , 1)

  iconMarkerGenerator: (marker_name, width=32, height=37) ->
    me = @
    if (me.icon_cache.hasOwnProperty(marker_name))
      return me.icon_cache[marker_name]


    #store icon as a property of Map
    me.icon_cache[marker_name] =
      size: new google.maps.Size(width, height, "px", "px")
      url: '/assets/markers/' + marker_name + '.png'

    return me.icon_cache[marker_name]

  ###
   Creates street view in specified container.
   @param container jQuery selected element
   @param location google.maps.latLng or [lat, lng] array
  ###
  getOrCreateStreetView: (container, location) ->
    me = @
    if (me.streetViewActive != undefined && me.streetViewActive)
      return
    else
      me.streetViewActive = true

    streetViewService = new google.maps.StreetViewService()

    #Check if street view exists for specified location
    streetViewService.getPanoramaByLocation(location, 50, (panorama, status) ->
      if (status != google.maps.StreetViewStatus.OK)
        $('#streetview').html('<h3>Street View neexistuje pre zobrazovaný inzerát</h3>')
      else
        me.createBasicMap(container, location, 15)
        container.gmap3({
          streetviewpanorama: {
            options: {
              container: container,
              opts: {
                position: location,
                pov: {
                  heading: google.maps.geometry.spherical.computeHeading(
                    panorama.location.latLng,
                    location),
                  pitch: 0
                }
              }
            }
          }
        })
    )

  ###
   Gets nearby POIs for specified location
   @param location google.maps.latLng
   @param return array of POIs (markers)
  ###

  getNearbyPOIs: (container, location)  ->
    me = @
    if (me.pois_loaded != undefined && me.pois_loaded)
      return

    #Cached POI markers.
    me.poi_markers = []
    #Is the async loading of POIs complete?
    me.pois_loaded = false

    #hash map used for identifying POIs
    poi_hash = {
      'café' : 'coffee',
      'národná' : 'congress',
      'kaffee' : 'coffee',
      'palác' : 'palace',
      'hostel' : 'hostel',
      'filharmónia' : 'music_classical',
      'kafé' : 'coffee',
      'restaurant' : 'restaurant',
      'bar' : 'bar_coktail',
      'hotel' : 'hotel',
      'tehelné' : 'stadium',
      'rozhlas' : 'music_live',
      'hotel****' : 'hotel',
      'univerzita' : 'university',
      'aréna' : 'theater',
      'divadlo' : 'theater',
      'parlamentka' : 'restaurant',
      'hotel' : 'hotel',
      'lékáreň' : 'drugstore',
      'lekáreň' : 'drugstore',
      'lidl' : 'mall',
      'tesco' : 'mall',
      'pizzeria' : 'pizzaria',
      'pizza' : 'pizzaria',
      'salaš' : 'restaurant',
      'kaderníctvo' : 'barber',
      'ck' : 'travel_agency',
      'zlatníctvo' : 'jewelry',
      'gymnázium' : 'university',
      'poliklinika' : 'hospital-building',
      'autopožičovňa-CK' : 'carrental',
      'pub' : 'bar',
      'krásy' : 'beautysalon',
      'squash' : 'squash'
    }

    #POI API request
    poi_request = {
      location: location,
      radius: 1200,
      types: ['restaurant', 'bank', 'bar', 'cafe', 'casino', 'cemetery',
        'church', 'doctor', 'food', 'gym', 'healt', 'hospital', 'park', 'parkin', 'museum',
      'store', 'police', 'school', 'post_office', 'university', 'finance', 'stadium', 'library', 'train_station'
      , 'shopping_mall']
    }

    me.createBasicMap(container, location, 17)
    map = container.gmap3('get')

    #initialize poi service
    poi_service = new google.maps.places.PlacesService(map)

    poi_service.nearbySearch(poi_request, (results, status, pagination) ->
      if (status != google.maps.places.PlacesServiceStatus.OK)
        return

      #create markers from POIs
      for place in results
        place_type = place.types[0]
        if (place_type == "establishment")
          #Establishments don't have nice icon.
          #Let's split the name of the place and see
          #if we have it in our poi_hash.
          place_name = place.name.split(" ")
          for name_part in place_name
            name = poi_hash[name_part.toLowerCase()]
            if (name != undefined)
              place_type = name
              break

        me.poi_markers.push({
          latLng: place.geometry.location,
          data: place.name,
          options: {icon: me.iconMarkerGenerator(place_type)},
        })

      if (pagination.hasNextPage)
        pagination.nextPage()
      else
        me.pois_loaded = true

        #trigger 'pois_loaded' so map will update with newly loaded markers
        $(document).trigger("pois_loaded")
    )

  #Creates POI Map and listens to the 'pois_loaded' event so it will draw new
  #markers after they have been loaded
  getOrCreatePOIsMap: (container, property) ->
    me = @
    if (me.poi_map_active != undefined && me.poi_map_active)
      return
    else
      me.poi_map_active = true

    #Add current property marker to the map.
    me.poi_markers.push(property)

    #Mouseover marker displays infowindow with place's name and mouseout hides
    #this infowindow.
    events = {
      mouseover: (marker, event, context) ->
        map = container.gmap3("get")
        infowindow = container.gmap3({
          get:{
            name:"infowindow"
          }
        })

        if (infowindow)
          infowindow.open(map, marker)
          infowindow.setContent(context.data)
        else
          container.gmap3({
            infowindow:{
              anchor:marker,
              options:{content: context.data}
            }
          })
    ,
    mouseout: () ->
      infowindow = container.gmap3({
        get: {
          name: "infowindow"
        }
      })

      if (infowindow)
        infowindow.close()
    }

    me._loadMarkers(container, me.poi_markers, events)
    $(document).bind('pois_loaded', () ->
      me._clearMarkersFromMap(container)
      me._loadMarkers(container, me.poi_markers, events)
    )



window.Map = Map


