express = require 'express'
http = require 'http'
fs = require 'fs'

app = express()

app.configure ->
  app.set 'port', process.env.PORT or 8005
  app.set 'views', "#{__dirname}/views"
  app.set "view options", {layout: false}
  app.engine "html", (path, options, fn) ->
    fs.readFile path, "utf8", (err, str) -> fn null, str
  
  # app.use express.favicon "#{__dirname}/public/favicon.ico" # Short circut the rest of the routes to serve the favicon, 4MAXSPEED
  app.use express.logger ':remote-addr - - [:date] ":method :req[host] :url" :status'
  app.use express.bodyParser()
  app.use express.methodOverride()

app.configure 'development', ->
  app.set 'host', '42foo.com'
  app.use express.errorHandler({ dumpExceptions: true, showStack: true })

app.configure 'production', ->
  app.set 'host', 'realtime-dta.templaedhel.com'
  app.use express.errorHandler()

app.configure ->
  app.use app.router
  app.use express.static("#{__dirname}/public")

app.get "/", (req, res) -> res.render "index.html"

http.createServer(app).listen app.get('port'), ->
  console.log "Express server listening on port #{app.get('port')}"
  console.log app.settings

process.on 'uncaughtException', (err) -> # Make sure it never crashes
  console.log 'Uncaught Error'
  console.log err
