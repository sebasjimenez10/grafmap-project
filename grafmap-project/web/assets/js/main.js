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

    GrafMap.prototype.map = null;

    function GrafMap() {
      this.getNearbyPlaces = __bind(this.getNearbyPlaces, this);
      this.addNearbyPlace = __bind(this.addNearbyPlace, this);
      this.navigatorSuccess = __bind(this.navigatorSuccess, this);
      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(this.navigatorSuccess, this.navigatorError);
      } else {
        alert("Oops, your browser doesn't support geo-location.");
      }
    }

    GrafMap.prototype.navigatorSuccess = function(position) {
      var latlng, marker, myOptions, s;
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
      this.map = new google.maps.Map(document.getElementById("map"), myOptions);
      marker = new google.maps.Marker({
        position: latlng,
        map: this.map,
        title: "You are here! (at least within a " + position.coords.accuracy + " meter radius)",
        animation: google.maps.Animation.DROP
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

    GrafMap.prototype.addNearbyPlace = function(place) {
      var contentHtmlString, infowindow, latlng, marker;
      console.log(place);
      contentHtmlString = "<div class=\"info-window\">\n  <div class=\"content-frame\">\n    <h3>" + place.name + "</h3>\n    <p>" + place.description + "</p>\n  </div>\n</div>";
      latlng = new google.maps.LatLng(place.location.latitude, place.location.longitude);
      marker = new google.maps.Marker({
        position: latlng,
        map: this.map,
        animation: google.maps.Animation.DROP
      });
      infowindow = new google.maps.InfoWindow({
        content: contentHtmlString
      });
      return google.maps.event.addListener(marker, "click", function() {
        return infowindow.open(this.map, marker);
      });
    };

    GrafMap.prototype.getNearbyPlaces = function() {
      var _this = this;
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
        var place, _i, _len, _ref, _results;
        console.log(data);
        _ref = data.data;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          place = _ref[_i];
          _results.push(_this.addNearbyPlace(place));
        }
        return _results;
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