express   = require 'express'
configure = require './configure'
route     = require './route'

app = express.createServer()

configure app
route app
module.exports = app
