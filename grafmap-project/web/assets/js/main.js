(function() {
  var GrafMap, grafmap, onFBConnected,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

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
        return onFBConnected();
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
    GrafMap.prototype.found = false;

    GrafMap.prototype.coords = null;

    GrafMap.prototype.access_token = null;

    function GrafMap() {
      this.getNearbyPlaces = __bind(this.getNearbyPlaces, this);
      this.navigatorSuccess = __bind(this.navigatorSuccess, this);
      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(this.navigatorSuccess, this.navigatorError);
      } else {
        alert("Oops, your browser doesn't support geo-location.");
      }
    }

    GrafMap.prototype.navigatorSuccess = function(position) {
      var latlng, map, marker, myOptions, s;
      this.coords = position.coords;
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
      marker = new google.maps.Marker({
        position: latlng,
        map: map,
        title: "You are here! (at least within a " + position.coords.accuracy + " meter radius)"
      });
      this.found = true;
      if (this.access_token) {
        return this.getNearbyPlaces();
      }
    };

    GrafMap.prototype.navigatorError = function(msg) {
      var s;
      s = document.querySelector("#status");
      s.innerHTML = (typeof msg === "string" ? msg : "failed");
      return s.className = "fail";
    };

    GrafMap.prototype.getNearbyPlaces = function() {
      console.log('Getting nearby places...');
      return $.get("https://graph.facebook.com/search", {
        type: 'place',
        fields: 'category,picture,name,can_post,phone,description,location',
        center: "" + this.coords.latitude + "," + this.coords.longitude,
        distance: 150,
        limit: 25,
        offset: 0,
        access_token: this.access_token
      }, function(data) {
        return console.log(data);
      });
    };

    return GrafMap;

  })();

  grafmap = null;

  $(function() {
    return grafmap = new GrafMap;
  });

  $(window).resize(function() {
    var h;
    h = $(window).height();
    return $("#map").css("height", h);
  }).resize();

  onFBConnected = function() {
    console.log("Welcome!  Fetching your information.... ");
    grafmap.access_token = FB.getAuthResponse()['accessToken'];
    if (grafmap.found) {
      grafmap.getNearbyPlaces();
    }
    return FB.api("/me", function(response) {
      return console.log("Good to see you, " + response.name + ".");
    });
  };

}).call(this);

/*
//@ sourceMappingURL=main.js.map
*/