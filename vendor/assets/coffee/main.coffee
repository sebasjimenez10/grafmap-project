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
  # Feedback while processing 
  $(this).html("<i class='fa fa-refresh fa-spin'></i> Favorite")
  $(this).attr('disabled','disabled')
  grafmap.favoritePlace obj, () =>
    $(this).html("<i class='fa fa-star'></i> Favorited")