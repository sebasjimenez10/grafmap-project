class GrafMap

  found: false
  coords: null
  access_token: null
  map: null

  constructor: () ->
    if navigator.geolocation 
      navigator.geolocation.getCurrentPosition @navigatorSuccess, @navigatorError
    else
      alert "Oops, your browser doesn't support geo-location."

  navigatorSuccess:(position) =>
    @coords = position.coords
    s = document.querySelector("#status")
    
    # not sure why we're hitting this twice in FF, I think it's to do with a cached result coming back    
    return  if s.className is "success"
    s.innerHTML = "found you!"
    s.className = "success"

    latlng = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
    myOptions =
      zoom: 15
      center: latlng
      mapTypeControl: true
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
    s = document.querySelector("#status")
    s.innerHTML = (if typeof msg is "string" then msg else "failed")
    s.className = "fail"

  addNearbyPlace: (place) =>
    console.log place

    tempalteSource = $("#info-window-template").html()
    template = Handlebars.compile(tempalteSource)
    contentHtmlString = template(place)

    latlng = new google.maps.LatLng(place.location.latitude, place.location.longitude)    
    marker = new google.maps.Marker(
      position: latlng
      map: @map
      icon:
        path: fontawesome.markers.EXCLAMATION
        scale: 0.5
        strokeWeight: 0.2
        strokeColor: 'black'
        strokeOpacity: 1
        fillColor: '#f8ae5f'
        fillOpacity: 0.7
      animation: google.maps.Animation.DROP
    )
    # Create info window
    infowindow = new google.maps.InfoWindow(content: contentHtmlString)
    google.maps.event.addListener marker, "click", ->
      infowindow.open @map, marker



  getNearbyPlaces: () =>
    console.log 'Getting nearby places...'
    $.get "https://graph.facebook.com/search",
      type: 'place'
      fields: 'category,picture,name,can_post,phone,description,location'
      center: "#{@coords.latitude},#{@coords.longitude}"
      distance: 150
      limit: 25
      offset: 0
      access_token: @access_token
    , (data) =>
      console.log data
      @addNearbyPlace place for place in data.data
