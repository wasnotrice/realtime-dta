// Generated by CoffeeScript 1.6.2
(function() {
  var add_bus, buses, firebus, map;

  buses = {};

  firebus = new Firebase("https://realtime-dta.firebaseio.com/duluth-transit-authority");

  map = new google.maps.Map(document.getElementById("map"), {
    center: new google.maps.LatLng(46.7833, -92.1064),
    zoom: 13,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  });

  add_bus = function(bus, firebase_id) {
    var marker;

    if (!bus.route) {
      return;
    }
    marker = new MarkerWithLabel({
      position: new google.maps.LatLng(bus.lat, bus.lon),
      map: map,
      draggable: false,
      labelContent: bus.route.short_name,
      labelClass: "route_card",
      icon: "#"
    });
    return buses[firebase_id] = {
      bus: bus,
      marker: marker
    };
  };

  firebus.once("value", function(agency_ref) {
    return agency_ref.forEach(function(bus_ref) {
      return add_bus(bus_ref.val(), bus_ref.name());
    });
  });

  firebus.on("child_changed", function(bus_ref) {
    var bus;

    bus = buses[bus_ref.name()];
    if (typeof bus === "undefined") {
      return add_bus(bus_ref.val(), bus_ref.name());
    } else {
      return bus.marker.animatedMoveTo(bus_ref.val().lat, bus_ref.val().lon);
    }
  });

  firebus.on("child_removed", function(bus_ref) {
    var bus;

    bus = buses[bus_ref.name()];
    if (typeof bus !== "undefined") {
      map.removeOverlay(bus.marker);
      return delete buses[bus_ref.name()];
    }
  });

}).call(this);