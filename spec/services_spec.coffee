services = require '../lib/services'
_        = require 'underscore'
mockData =
  34563:
    priority: 1
    name: "Control Panel"
    match: "^/users"
    live: "http://www.netflix.com"
    local: "http://localhost:8081"
    proxy: on
  3434:
    priority: 5
    name: "CSS and static resources"
    match: "^/"
    live: "http://www.yahoo.com"
    local: "http://localhost:8080"
    proxy: on
  3241233:
    priority: 2
    name: "JSON API"
    match: "^/resources"
    live: "http://www.google.com"
    local: "http://localhost:8082"
    proxy: on

given = (url, expect, host, local)->
  match = if local then "localhost:#{host}" else "www.#{host}.com"
  expect(services.match(url)).toEqual "http://#{match}"
describe 'services', ->

  beforeEach ->
    dataSet = {}
    _.extend dataSet, mockData
    services.loadData dataSet

  it 'should have the data loaded', ->
    expect(services.data()).toEqual mockData

  it 'should return sorted data', ->
    sorted = services.sorted()
    priorities = _(sorted).map (item)-> item.priority
    expect(priorities).toEqual [1, 2, 5]

  it 'should flip the proxy switch', ->
    services.disable 3241233
    expect(services.get(3241233).proxy).toBe off
    services.enable 3241233
    expect(services.get(3241233).proxy).toBe on

  it 'should flip the proxy switch, as well', ->
    services.turn 3241233, off
    expect(services.get(3241233).proxy).toBe off
    services.turn 3241233, on
    expect(services.get(3241233).proxy).toBe on

  describe 'matching URLs', ->

    it 'should match proxies', ->
      given '/users',         expect, 'netflix'
      given '/users/admin',   expect, 'netflix'
      given '/foo',           expect, 'yahoo'
      given '/bar/users',     expect, 'yahoo'
      given '/resources',     expect, 'google'
      given '/resources/baz', expect, 'google'

    it 'should match local resources', ->
      services.turn 3241233, off
      given '/users',         expect, 'netflix'
      given '/users/admin',   expect, 'netflix'
      given '/foo',           expect, 'yahoo'
      given '/bar/users',     expect, 'yahoo'
      given '/resources',     expect, '8082', yes
      given '/resources/baz', expect, '8082', yes

    it 'should match local resources and default', ->
      services.turn 3241233, off
      services.turn 3434, off
      services.turn 34563, off
      given '/users',         expect, '8081', yes
      given '/users/admin',   expect, '8081', yes
      given '/foo',           expect, '8080', yes
      given '/bar/users',     expect, '8080', yes
      given '/resources',     expect, '8082', yes
      given '/resources/baz', expect, '8082', yes
