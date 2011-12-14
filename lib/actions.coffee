services = require './services'
module.exports =
  index: (req, res)-> res.render 'index'
  getService: (req, res)->
    res.json services.get req.params.id
  getServices:  (req, res)->
    res.json services.data()
  disableService: (req, res)->
    services.turn req.params.id ,off
    res.json services.get req.params.id
  enableService:  (req, res)->
    services.turn req.params.id, on
    res.json services.get req.params.id

