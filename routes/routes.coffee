Quote = require '../models/quote'
makeIpsum = require './make_ipsum'

base_partials =
  head: "head"

module.exports = (app) ->
  app.use (req, res, next) ->
    console.log "%s %s", req.method, req.url
    next()
    return

  app.get "/", (req, res) ->

    num_paragraphs = req.query.paras;
    if num_paragraphs != undefined
      makeIpsum num_paragraphs, (results)->
        
        ipsum_partials = base_partials
        res.locals =
          data: results.paragraphs
        res.render "index",
          partials: ipsum_partials
    
    else
      index_partials = base_partials
      res.render "index",
        partials: index_partials




  app.get "/submit", (req, res) ->
    index_partials = base_partials
    res.render "submit",
      partials: index_partials
      
  app.post '/submit', (req, res) ->
    quote = new Quote()
    quote.text = req.body.quote
    quote.movie = req.body.movie

    quote.save (err) ->
      if err
        res.send err
      res.json
        message: "quote created!"