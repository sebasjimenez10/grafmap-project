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