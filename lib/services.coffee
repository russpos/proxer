_ = require 'underscore'

sorted = no
data =
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

sort = (set)->
  sorted or sorted = _(set).values().sort (a, b)-> a.priority > b.priority

switchProxy = (id, state)->
  if not data?[id]?.proxy? then no else (data[id].proxy = state) or yes

module.exports =
  loadData: (newData)->
    data = newData
    sorted = no
    sort data
  data:        -> data
  get:     (id)-> data[id]
  sorted:      -> sort data
  turn:    (id, val)-> switchProxy id, !!val
  enable:  (id)-> switchProxy id, on
  disable: (id)-> switchProxy id, off
  match:  (url)->
    for service in sorted
      if url.match new RegExp service.match
        return if service.proxy then service.live else service.local
    if service.proxy then service.live else service.local



