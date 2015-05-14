mongoose = require 'mongoose'
Schema = mongoose.Schema;

quoteSchema = new Schema
  text: String
  movie: String
  character: String

module.exports = mongoose.model 'Quote', quoteSchema
