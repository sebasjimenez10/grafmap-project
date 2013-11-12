window.fbAsyncInit = ->
  FB.init
    appId: "1418352478394130"
    channelUrl: "//connect.facebook.net/en_US/all.js"
    status: true
    cookie: true
    xfbml: true

  FB.Event.subscribe "auth.authResponseChange", (response) ->
    if response.status is "connected"
      onFBConnected()
    else if response.status is "not_authorized"
      FB.login()
    else
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
        path: fontawesome.markers.STAR_EMPTY
        scale: 0.5
        strokeWeight: 0.2
        strokeColor: 'black'
        strokeOpacity: 1
        fillColor: '#D8432E'
        fillOpacity: 0.8
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
      fields: 'category,picture,name,can_post,phone,description,location,link'
      center: "#{@coords.latitude},#{@coords.longitude}"
      distance: 150
      limit: 25
      offset: 0
      access_token: @access_token
    , (data) =>
      console.log data
      @addNearbyPlace place for place in data.data

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
  grafmap.getNearbyPlaces() if grafmap.found
  FB.api "/me", (response) ->
    console.log "Good to see you, " + response.name + "."
String::truncate = (n) ->
  @substr(0, n - 1) + ((if @length > n then "..." else ""))

Handlebars.registerHelper "truncate", (str, len) ->
  str.truncate(len)  