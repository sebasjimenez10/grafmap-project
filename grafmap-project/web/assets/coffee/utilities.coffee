String::truncate = (n) ->
  @substr(0, n - 1) + ((if @length > n then "..." else ""))


# Handlebar helpers
Handlebars.registerHelper "truncate", (str, len) ->
  if str?
    str.truncate(len)
  else
    ''
Handlebars.registerHelper "favoritedText", (id) ->
  if grafmap.myNearbyPlaces[id]?
    "<i class='fa fa-star'></i> Favorited"
  else
    "<i class='fa fa-star-o'></i> Favorite"

Handlebars.registerHelper "favoritedClass", (id) ->
  if grafmap.myNearbyPlaces[id]?
    "favorited"
  else
    "favorite"

Handlebars.registerHelper "isDisable", (id) ->
  if grafmap.myNearbyPlaces[id]?
    "disabled='disabled'"
  else
    ""

Messenger.options =
  extraClasses: "messenger-fixed messenger-on-bottom messenger-on-right"
  theme: "future"
  parentLocations: [".col-md-10"]