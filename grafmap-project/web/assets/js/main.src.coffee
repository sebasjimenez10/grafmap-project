testAPI = ->
  console.log "Welcome!  Fetching your information.... "
  FB.api "/me", (response) ->
    console.log "Good to see you, " + response.name + "."

window.fbAsyncInit = ->
  FB.init
    appId: "1418352478394130"
    channelUrl: "//connect.facebook.net/en_US/all.js"
    status: true
    cookie: true
    xfbml: true

  FB.Event.subscribe "auth.authResponseChange", (response) ->
    if response.status is "connected"
      testAPI()
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
  constructor: () ->
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition @success, @error
    else
      alert "Oops, your browser doesn't support geo-location."

  success:(position) ->
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

    map = new google.maps.Map(document.getElementById("map"), myOptions)
    marker = new google.maps.Marker(
      position: latlng
      map: map
      title: "You are here! (at least within a " + position.coords.accuracy + " meter radius)"
    )

  error: (msg) ->
    s = document.querySelector("#status")
    s.innerHTML = (if typeof msg is "string" then msg else "failed")
    s.className = "fail"
$ ->
  grafmap = new GrafMap
# console.log(arguments);


# Calculate the top offset
$(window).resize(->
  h = $(window).height()
  $("#map").css "height", h
).resize()