express = require 'express'
proxy   = require './proxy'
path    = require 'path'

module.exports = (app)->

  app.configure ->
    app.use express.methodOverride()
    app.use express.bodyParser()
    app.use (req, res, next)->
      if req.url.match /^\/__admin/
        req.url = req.url.replace '/__admin/', '' or '/'
        return next()
      proxy req, res
    app.use app.router
    app.use express.static path.join __dirname, '/../public'
    app.use express.errorHandler dumpExceptions: true, showStack: true

    # Load views
    app.set 'views', path.join __dirname, '/../views'
    app.set 'view engine', 'jade'
