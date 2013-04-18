Firebase = require "firebase"
_ = require "underscore"
async = require "async"
quest = require "quest"
crc = require "crc"

firebus = new Firebase "https://realtime-dta.firebaseio.com/"

agency = "duluth-transit-authority"
routes = require "./routes"
url = "http://webwatch.duluthtransit.com/GoogleMap.aspx/getVehicles"

delay = (ms, func) -> setTimeout func, ms

clean_firebase = ->
  run_time = Date.now() / 1000
  firebus.child(agency).once "value", (buses) ->
    buses.forEach (bus_ref) ->
      bus = bus_ref.val()
      age = run_time - bus.last_updated
      bus_ref.ref().remove() if age > 60

update_firebase = (cb) ->
  console.log "Running Update"
  async.each routes, (route, cb_e) ->
    console.log "Updating #{route.name}"
    async.waterfall [(cb_wf) ->
      options =
        method: "POST"
        url: url
        json: 
          routeID: route.id
      quest options, cb_wf
    (resp, body, cb_wf) ->
      return cb_wf() unless body?.d?.length > 0
      for bus in body.d
        bus.route = route
        bus.last_updated = new Date().getTime() / 1000
        firebase_id = "#{bus.propertyTag}#{route.id}"
        firebus.child(agency).child(firebase_id).set(bus)
      cb_wf()
    ],cb_e
  , (err) ->
    console.log "Done!"
    cb(err)
    clean_firebase()

run_forever = -> update_firebase () -> delay 3000, run_forever
run_forever()