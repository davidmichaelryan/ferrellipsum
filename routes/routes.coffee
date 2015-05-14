makeIpsum = require './make_ipsum'

base_partials =
  head: "head"

module.exports = (app) ->
  app.use (req, res, next) ->
    console.log "%s %s", req.method, req.url
    next()
    return

  app.get "/", (req, res) ->
    index_partials = base_partials
    res.render "index",
      partials: index_partials


  app.get "/ipsum", (req, res) ->  
    
    num_paragraphs = req.query.paras;

    makeIpsum num_paragraphs, (results)->
      
      ipsum_partials = base_partials 
      res.locals =
        data: results.paragraphs
      res.render "index",
        partials: ipsum_partials
      
        
