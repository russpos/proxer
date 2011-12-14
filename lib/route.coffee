actions = require './actions'

module.exports = (app)->
  # Main view
  app.get '/', actions.index

  # Ajax methods
  app.get  '/services.json',     actions.getServices
  app.get  '/services/:id.json', actions.getService
  app.del  '/services/:id.json', actions.disableService
  app.post '/services/:id.json', actions.enableService

