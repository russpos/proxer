b = do -> if require? and not Backbone? then require 'backbone' else Backbone

Service = b.Model.extend

  initialize: ->
    @enabled = true
  id: -> @name.toLowerCase().replace '/ /g', '_'

if window? then window.Service = Service else module.exports = Service
