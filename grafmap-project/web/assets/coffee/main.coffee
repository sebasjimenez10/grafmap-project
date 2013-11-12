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
  console.log grafmap.access_token
  grafmap.getNearbyPlaces() if grafmap.found
  fields = 'id,name,username,picture,name'
  FB.api "/me?fields=#{fields}", (response) ->
    $('#profile_user img').attr('src',"https://graph.facebook.com/#{response.username}/picture?type=normal")
    $('#profile_user .name').text(response.name)
    console.log response
    console.log "Good to see you, " + response.name + "."


# Binding

# Login
$('#fb_button_login').on 'click', (e) ->
  e.preventDefault()
  FB.login()

# Favorite place
$(document).on 'click', '.favorite_button', (e) ->
  grafmap.favoritePlace($(this).data('place-id'))