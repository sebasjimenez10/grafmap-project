(function() {
  var GrafMap, testAPI;

  testAPI = function() {
    console.log("Welcome!  Fetching your information.... ");
    return FB.api("/me", function(response) {
      return console.log("Good to see you, " + response.name + ".");
    });
  };

  window.fbAsyncInit = function() {
    FB.init({
      appId: "1418352478394130",
      channelUrl: "//connect.facebook.net/en_US/all.js",
      status: true,
      cookie: true,
      xfbml: true
    });
    return FB.Event.subscribe("auth.authResponseChange", function(response) {
      if (response.status === "connected") {
        return testAPI();
      } else if (response.status === "not_authorized") {
        return FB.login();
      } else {
        return FB.login();
      }
    });
  };

  (function(d) {
    var id, js, ref;
    js = void 0;
    id = "facebook-jssdk";
    ref = d.getElementsByTagName("script")[0];
    if (d.getElementById(id)) {
      return;
    }
    js = d.createElement("script");
    js.id = id;
    js.async = true;
    js.src = "//connect.facebook.net/en_US/all.js";
    return ref.parentNode.insertBefore(js, ref);
  })(document);

  GrafMap = (function() {
    function GrafMap() {
      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(this.success, this.error);
      } else {
        alert("Oops, your browser doesn't support geo-location.");
      }
    }

    GrafMap.prototype.success = function(position) {
      var latlng, map, marker, myOptions, s;
      s = document.querySelector("#status");
      if (s.className === "success") {
        return;
      }
      s.innerHTML = "found you!";
      s.className = "success";
      latlng = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
      myOptions = {
        zoom: 15,
        center: latlng,
        mapTypeControl: true,
        navigationControlOptions: {
          style: google.maps.NavigationControlStyle.SMALL
        },
        mapTypeId: google.maps.MapTypeId.ROADMAP
      };
      map = new google.maps.Map(document.getElementById("map"), myOptions);
      return marker = new google.maps.Marker({
        position: latlng,
        map: map,
        title: "You are here! (at least within a " + position.coords.accuracy + " meter radius)"
      });
    };

    GrafMap.prototype.error = function(msg) {
      var s;
      s = document.querySelector("#status");
      s.innerHTML = (typeof msg === "string" ? msg : "failed");
      return s.className = "fail";
    };

    return GrafMap;

  })();

  $(function() {
    var grafmap;
    return grafmap = new GrafMap;
  });

  $(window).resize(function() {
    var h;
    h = $(window).height();
    return $("#map").css("height", h);
  }).resize();

}).call(this);

/*
//@ sourceMappingURL=main.js.map
*/