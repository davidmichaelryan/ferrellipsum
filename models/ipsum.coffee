mongoose = require 'mongoose'
Schema = mongoose.Schema

ipsumSchema = new Schema
  text: String

module.exports = mongoose.model 'Ipsum', ipsumSchema