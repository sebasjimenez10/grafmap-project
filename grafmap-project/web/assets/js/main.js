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
        $('.button_login').hide();
        $('#profile_user').show();
        return onFBConnected();
      } else if (response.status === "not_authorized") {
        $('.button_login').show();
        return FB.login();
      } else {
        $('.button_login').show();
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

    GrafMap.prototype.userId = null;

    GrafMap.prototype.map = null;

    GrafMap.prototype.markers = {};

    GrafMap.prototype.myNearbyPlaces = {};

    function GrafMap() {
      this.favoritePlace = __bind(this.favoritePlace, this);
      this.getNearbyPlaces = __bind(this.getNearbyPlaces, this);
      this.setMyNearbyPlaces = __bind(this.setMyNearbyPlaces, this);
      this.addNearbyPlace = __bind(this.addNearbyPlace, this);
      this.navigatorSuccess = __bind(this.navigatorSuccess, this);
      Messenger().post({
        message: 'Finding your location...',
        id: 'alerter',
        type: 'info'
      });
      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(this.navigatorSuccess, this.navigatorError);
      } else {
        Messenger().post({
          message: "Oops, your browser doesn't support geo-location.",
          id: 'alerter',
          type: 'error'
        });
      }
    }

    GrafMap.prototype.navigatorSuccess = function(position) {
      var latlng, marker, myOptions;
      Messenger().post({
        message: 'We found you!',
        id: 'alerter',
        type: 'success',
        showCloseButton: true
      });
      this.coords = position.coords;
      latlng = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
      myOptions = {
        zoom: 17,
        center: latlng,
        mapTypeControl: false,
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
      return Messenger().post({
        message: 'Error trying to find your location...',
        id: 'alerter',
        type: 'error'
      });
    };

    GrafMap.prototype.addNearbyPlace = function(place) {
      var contentHtmlString, infowindow, latlng, marker, tempalteSource, template;
      tempalteSource = $("#info-window-template").html();
      template = Handlebars.compile(tempalteSource);
      contentHtmlString = template(place);
      latlng = new google.maps.LatLng(place.location.latitude, place.location.longitude);
      marker = new google.maps.Marker({
        position: latlng,
        map: this.map,
        icon: this.getIcon(this.myNearbyPlaces[place.id] != null),
        animation: google.maps.Animation.DROP
      });
      this.markers[place.id] = marker;
      infowindow = new google.maps.InfoWindow({
        content: contentHtmlString
      });
      return google.maps.event.addListener(marker, "click", function() {
        return infowindow.open(this.map, marker);
      });
    };

    GrafMap.prototype.setMyNearbyPlaces = function(cb) {
      var _this = this;
      return $.get("/grafmap-project/webresources/favorite/" + this.userId, function(data) {
        var place, _i, _len;
        for (_i = 0, _len = data.length; _i < _len; _i++) {
          place = data[_i];
          _this.myNearbyPlaces[place.id] = place;
        }
        return cb();
      });
    };

    GrafMap.prototype.getNearbyPlaces = function() {
      var _this = this;
      console.log('Getting nearby places...');
      return $.get("https://graph.facebook.com/search", {
        type: 'place',
        fields: 'category,picture,name,can_post,phone,description,location,link,likes',
        center: "" + this.coords.latitude + "," + this.coords.longitude,
        distance: 500,
        limit: 30,
        offset: 0,
        access_token: this.access_token
      }, function(data) {
        var place, _i, _len, _ref, _results;
        _ref = data.data;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          place = _ref[_i];
          _results.push(_this.addNearbyPlace(place));
        }
        return _results;
      });
    };

    GrafMap.prototype.favoritePlace = function(obj) {
      var marker, objToSend;
      objToSend = {
        id: "" + obj.placeId,
        user_id: this.userId,
        latitud: "" + obj.latitude,
        longitud: "" + obj.longitude
      };
      $.ajax({
        type: 'POST',
        url: '/grafmap-project/webresources/favorite',
        data: JSON.stringify(objToSend),
        dataType: 'json',
        contentType: 'application/json',
        success: function(data) {
          return console.log(data);
        }
      });
      marker = this.markers[obj.placeId];
      return marker.setIcon({
        path: fontawesome.markers.STAR,
        scale: 0.5,
        strokeWeight: 0.8,
        strokeColor: '#111',
        strokeOpacity: 1,
        fillColor: '#FFE168',
        fillOpacity: 1
      });
    };

    GrafMap.prototype.getIcon = function(favorited) {
      if (favorited) {
        return {
          path: fontawesome.markers.STAR,
          scale: 0.5,
          strokeWeight: 0.8,
          strokeColor: '#111',
          strokeOpacity: 1,
          fillColor: '#FFE168',
          fillOpacity: 1
        };
      } else {
        return {
          path: fontawesome.markers.STAR_EMPTY,
          scale: 0.5,
          strokeWeight: 0.2,
          strokeColor: 'black',
          strokeOpacity: 1,
          fillColor: '#D8432E',
          fillOpacity: 0.8
        };
      }
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
    var fields;
    console.log("Welcome!  Fetching your information.... ");
    grafmap.access_token = FB.getAuthResponse()['accessToken'];
    fields = 'id,name,username,picture,name';
    return FB.api("/me?fields=" + fields, function(response) {
      grafmap.userId = response.id;
      if (grafmap.found) {
        grafmap.setMyNearbyPlaces(grafmap.getNearbyPlaces);
      }
      $('#profile_user img').attr('src', "https://graph.facebook.com/" + response.username + "/picture?type=normal");
      $('#profile_user .name').text(response.name);
      return console.log("Good to see you, " + response.name + ".");
    });
  };

  $('#fb_button_login').on('click', function(e) {
    e.preventDefault();
    return FB.login();
  });

  $(document).on('click', '.favorite_button', function(e) {
    var obj;
    obj = {
      placeId: $(this).data('place-id'),
      latitude: $(this).data('latitude'),
      longitude: $(this).data('longitude')
    };
    return grafmap.favoritePlace(obj);
  });

  String.prototype.truncate = function(n) {
    return this.substr(0, n - 1) + (this.length > n ? "..." : "");
  };

  Handlebars.registerHelper("truncate", function(str, len) {
    if (str != null) {
      return str.truncate(len);
    } else {
      return '';
    }
  });

  Messenger.options = {
    extraClasses: "messenger-fixed messenger-on-top",
    theme: "future",
    parentLocations: [".col-md-10"]
  };

}).call(this);

/*
//@ sourceMappingURL=main.js.map
*/