buses = {}

firebus = new Firebase "https://realtime-dta.firebaseio.com/duluth-transit-authority"

#Map init
map = new google.maps.Map document.getElementById("map"), 
  center: new google.maps.LatLng(46.7833, -92.1064)
  zoom: 13
  mapTypeId: google.maps.MapTypeId.ROADMAP

add_bus = (bus, firebase_id) ->
  return  unless bus.route  
  marker = new MarkerWithLabel(
    position: new google.maps.LatLng(bus.lat,bus.lon)
    map: map
    draggable: off
    labelContent: bus.route.short_name
    labelClass: "route_card"
    icon: "#"
  )
  buses[firebase_id] = marker: marker

firebus.once "value", (agency_ref) ->
  agency_ref.forEach (bus_ref) -> 
    add_bus bus_ref.val(), bus_ref.name()

firebus.on "child_changed", (bus_ref) ->
  bus = buses[bus_ref.name()]
  if typeof bus is "undefined"
    add_bus bus_ref.val(), bus_ref.name()
  else
    bus.marker.animatedMoveTo bus_ref.val().lat,bus_ref.val().lon

firebus.on "child_removed", (bus_ref) ->
  bus = buses[bus_ref.name()]
  if typeof bus isnt "undefined"
    bus.marker.setMap(null)
    delete buses[bus_ref.name()]
