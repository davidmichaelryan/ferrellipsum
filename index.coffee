express = require 'express'
path = require 'path'
bodyParser = require 'body-parser'
morgan = require 'morgan'
mongoose = require 'mongoose'
require('dotenv').load();

app = express()
port = process.env.PORT || 5000
mongoose.connect process.env.MONGO_URI


app.use express.static path.join __dirname, 'build'
app.set 'views', path.join __dirname, 'templates'

app.use bodyParser.urlencoded { extended: true }
app.use bodyParser.json()

app.use morgan 'combined'

app.set 'view engine', 'mustache'
app.enable 'view cache'
app.engine 'mustache', require 'hogan-express'

require('./routes/routes') app

app.listen port
console.log 'Magic happens on port ' + port
exports = module.exports = app