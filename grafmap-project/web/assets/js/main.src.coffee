window.fbAsyncInit = ->
  FB.init
    appId: "1418352478394130"
    channelUrl: "//connect.facebook.net/en_US/all.js"
    status: true
    cookie: true
    xfbml: true

  FB.Event.subscribe "auth.authResponseChange", (response) ->
    if response.status is "connected"
      $('.button_login').hide()
      $('#profile_user').show()
      onFBConnected()
    else if response.status is "not_authorized"
      $('.button_login').show()
      FB.login()
    else
      $('.button_login').show()
      FB.login()


((d) ->
  js = undefined
  id = "facebook-jssdk"
  ref = d.getElementsByTagName("script")[0]
  return  if d.getElementById(id)
  js = d.createElement("script")
  js.id = id
  js.async = true
  js.src = "//connect.facebook.net/en_US/all.js"
  ref.parentNode.insertBefore js, ref
) document
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

    tempalteSource = $("#info-window-template").html()
    template = Handlebars.compile(tempalteSource)
    contentHtmlString = template(place)

    latlng = new google.maps.LatLng(place.location.latitude, place.location.longitude)    
    marker = new google.maps.Marker(
      position: latlng
      map: @map
      icon: @getIcon @myNearbyPlaces[place.id]?
      animation: google.maps.Animation.DROP
    )

    # Add to markers array
    @markers[place.id] = marker

    # Create info window
    infowindow = new google.maps.InfoWindow(content: contentHtmlString)
    google.maps.event.addListener marker, "click", ->
      infowindow.open @map, marker

  setMyNearbyPlaces: (cb) =>
    $.get "http://localhost:8080/grafmap-project/webresources/favorite/#{@userId}", (data) =>
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

  favoritePlace: (obj) =>

    objToSend = 
        id: "#{obj.placeId}"
        user_id: @userId
        latitud: "#{obj.latitude}"
        longitud: "#{obj.longitude}"

    $.ajax
      type: 'POST'
      url: 'http://localhost:8080/grafmap-project/webresources/favorite'
      data: JSON.stringify objToSend
      dataType: 'json'
      contentType: 'application/json'    
      success: (data) ->
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
grafmap = null

$ ->
  grafmap = new GrafMap

# Calculate the top offset
$(window).resize(->
  h = $(window).height()
  $("#map").css "height", h
).resize()

onFBConnected = ->
  console.log "Welcome!  Fetching your information.... "
  grafmap.access_token = FB.getAuthResponse()['accessToken']
  fields = 'id,name,username,picture,name'
  FB.api "/me?fields=#{fields}", (response) ->
    grafmap.userId = response.id
    # Set my nearby places and then get the nearby places around me.
    grafmap.setMyNearbyPlaces(grafmap.getNearbyPlaces) if grafmap.found    
    $('#profile_user img').attr('src',"https://graph.facebook.com/#{response.username}/picture?type=normal")
    $('#profile_user .name').text(response.name)
    console.log "Good to see you, " + response.name + "."


# Binding

# Login
$('#fb_button_login').on 'click', (e) ->
  e.preventDefault()
  FB.login()

# Favorite place
$(document).on 'click', '.favorite_button', (e) ->
  obj =
    placeId: $(this).data('place-id')
    latitude: $(this).data('latitude')
    longitude: $(this).data('longitude')
  grafmap.favoritePlace(obj)
String::truncate = (n) ->
  @substr(0, n - 1) + ((if @length > n then "..." else ""))

Handlebars.registerHelper "truncate", (str, len) ->
  if str?
    str.truncate(len)
  else
    ''

Messenger.options =
  extraClasses: "messenger-fixed messenger-on-top"
  theme: "future"
  parentLocations: [".col-md-10"]