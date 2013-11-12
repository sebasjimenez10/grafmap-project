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