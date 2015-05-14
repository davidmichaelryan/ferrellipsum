randomWord = (dictionary) ->
  i = Math.floor dictionary.length * Math.random()
  return dictionary[i];


makeStartWords = (cb, quotes)->
  start_words = []
  for quote in quotes 
    words = quote.split ' '
    for word in words 
      if word in start_words 
        
      else
        start_words.push word
  