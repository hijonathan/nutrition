fs = require 'fs'
express = require 'express'
sysPath = require 'path'

fullPath = sysPath.resolve 'config'
{config} = require fullPath

exports.startServer = (port, path, callback) ->
    app = express.createServer express.logger()
    port = parseInt(process.env.PORT or port, 10)

    # Express init
    app.configure ->
        app.use express.bodyParser()
        app.use express.methodOverride()
        app.use express.errorHandler
            dumpExceptions: true
            showStack: true

    # Serve our static assets
    app.use express.static("#{__dirname}/#{path}")

    # Since everything is client side, we only serve index.html
    serveIndex = (req, res) ->
        res.sendfile "#{__dirname}/#{path}/index.html"
    
    app.get "/food", serveIndex
    app.get "/help", serveIndex
    app.get "/about", serveIndex
    app.get "/stats", serveIndex
    app.get "/configure", serveIndex
    app.get "/food/:macro", serveIndex
    app.get "/food/:macro/:food", serveIndex

    # Serve it up!
    app.listen port, -> 
        console.info "Listening on #{port}, dawg"
    app

# We only start this up if we're not using brunch to run it. Pretty hacky, I know.
exports.startServer config.server.port, config.paths.public unless config.server.run?
