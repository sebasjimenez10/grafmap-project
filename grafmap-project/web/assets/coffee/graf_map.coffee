class GrafMap

  found: false
  coords: null
  access_token: null
  userId: null
  map: null
  markers: {}
  myNearbyPlaces:{}

  constructor: () ->

    Messenger().post
      message: 'Finding your location...'
      id: 'alerter'
      type: 'info'

    if navigator.geolocation 
      navigator.geolocation.getCurrentPosition @navigatorSuccess, @navigatorError
    else
      Messenger().post
        message: "Oops, your browser doesn't support geo-location."
        id: 'alerter'
        type: 'error'

  navigatorSuccess:(position) =>

    Messenger().post
      message: 'We found you!'
      id: 'alerter'
      type: 'success'
      showCloseButton: true 

    @coords = position.coords

    latlng = new google.maps.LatLng(position.coords.latitude,position.coords.longitude)
    myOptions =
      zoom: 17
      center: latlng
      mapTypeControl: false
      navigationControlOptions:
        style: google.maps.NavigationControlStyle.SMALL

      mapTypeId: google.maps.MapTypeId.ROADMAP

    @map = new google.maps.Map(document.getElementById("map"), myOptions)
    marker = new google.maps.Marker(
      position: latlng
      map: @map
      title: "You are here! (at least within a " + position.coords.accuracy + " meter radius)"
      animation: google.maps.Animation.DROP
    )

    @found = true
    @getNearbyPlaces() if @access_token

  navigatorError: (msg) ->
    Messenger().post
      message: 'Error trying to find your location...'
      id: 'alerter'
      type: 'error'


  addNearbyPlace: (place) =>

    latlng = new google.maps.LatLng(place.location.latitude, place.location.longitude)    
    marker = new google.maps.Marker(
      position: latlng
      map: @map
      icon: @getIcon @myNearbyPlaces[place.id]?
      animation: google.maps.Animation.DROP
    )

    # Add to markers array
    @markers[place.id] = marker
    @crateInfoWindow place, marker

  crateInfoWindow: (place, marker) =>
    tempalteSource = $("#info-window-template").html()
    template = Handlebars.compile(tempalteSource)
    contentHtmlString = template(place)
    # Create info window
    infowindow = new google.maps.InfoWindow(content: contentHtmlString)
    google.maps.event.addListener marker, "click", ->
      infowindow.open @map, marker    

  setMyNearbyPlaces: (cb) =>
    $.get "/grafmap-project/webresources/favorite/#{@userId}", (data) =>
      # Get my nearby places
      for place in data
        @myNearbyPlaces[place.id] = place
      cb()

  getNearbyPlaces: () =>
    console.log 'Getting nearby places...'
    $.get "https://graph.facebook.com/search",
      type: 'place'
      fields: 'category,picture,name,can_post,phone,description,location,link,likes'
      center: "#{@coords.latitude},#{@coords.longitude}"
      distance: 500
      limit: 30
      offset: 0
      access_token: @access_token
    , (data) =>
      @addNearbyPlace place for place in data.data

  favoritePlace: (obj,cb) =>

    objToSend = 
        id: "#{obj.placeId}"
        user_id: @userId
        latitud: "#{obj.latitude}"
        longitud: "#{obj.longitude}"

    $.ajax
      type: 'POST'
      url: '/grafmap-project/webresources/favorite'
      data: JSON.stringify objToSend
      dataType: 'json'
      contentType: 'application/json'    
      success: (data) =>
        console.log data
        # Re-paint the marker
        marker = @markers[obj.placeId]
        marker.setIcon
          path: fontawesome.markers.STAR
          scale: 0.5
          strokeWeight: 0.8
          strokeColor: '#111'
          strokeOpacity: 1
          fillColor: '#FFE168'
          fillOpacity: 1
        # Add the place to my places
        @myNearbyPlaces[obj.placeId] = objToSend
        # Re-paint the infoWindow and remove the listener
        google.maps.event.clearListeners marker, 'click'
        $.get "https://graph.facebook.com/#{obj.placeId}",
          fields: 'category,picture,name,can_post,phone,description,location,link,likes'
          access_token: @access_token
        , (place) =>
          @crateInfoWindow place, marker
          # Call the callback if any
          cb() if cb      

  getIcon: (favorited) ->
    if favorited
      path: fontawesome.markers.STAR
      scale: 0.5
      strokeWeight: 0.8
      strokeColor: '#111'
      strokeOpacity: 1
      fillColor: '#FFE168'
      fillOpacity: 1
    else
      path: fontawesome.markers.STAR_EMPTY
      scale: 0.5
      strokeWeight: 0.2
      strokeColor: 'black'
      strokeOpacity: 1
      fillColor: '#D8432E'
      fillOpacity: 0.8