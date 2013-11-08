(function() {
  var error, success;

  success = function(position) {
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
      mapTypeControl: false,
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

  error = function(msg) {
    var s;
    s = document.querySelector("#status");
    s.innerHTML = (typeof msg === "string" ? msg : "failed");
    return s.className = "fail";
  };

  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(success, error);
  } else {
    alert("Oops, your browser doesn't support geo-location.");
  }

}).call(this);

/*
//@ sourceMappingURL=main.js.map
*/