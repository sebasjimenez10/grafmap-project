$ ->
  grafmap = new GrafMap
# console.log(arguments);


# Calculate the top offset
$(window).resize(->
  h = $(window).height()
  $("#map").css "height", h
).resize()