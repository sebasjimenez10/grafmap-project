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