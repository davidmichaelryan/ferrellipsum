Quote = require '../models/quote'
Ipsum = require '../models/ipsum'
async = require 'async'

wordList = ['are', 'a', 'go', 'to', 'on', 'in', 'of', 'not', 'a', 'by', 'the', 'it', 'has', 'and', 'like', 'I', 'was', 'if', 'is', 'an', 'or', 'are', 'be','have', 'into', 'this', '. ']
avg_paragraph_length = 400

shuffle = (callback, array)->
  currentIndex = array.length

  while 0 != currentIndex
    randomIndex = Math.floor Math.random() * currentIndex
    currentIndex -= 1

    temp = array[currentIndex]
    array[currentIndex] = array[randomIndex]
    array[randomIndex] = temp

  callback null, array

fixPeriods = (sentence)->
  if sentence[sentence.length - 1] == ' '
    sentence = sentence.substring(0, sentence.length-1)
  if sentence[sentence.length - 1] == '.'
    sentence = sentence.substring(0, sentence.length-1)
  if sentence[sentence.length - 1] == ','
    sentence = sentence.substring(0, sentence.length-1)
  sentence

getIpsumPhrase = (ipsum)->
  ipsum_sentences = ipsum.text.split '. '
  x = Math.floor Math.random()*ipsum_sentences.length

  ipsum_words = ipsum_sentences[x].split ' '
  if (ipsum_words.length > 5)
    ipsum_cutoff = Math.floor (1.0 - (0.7*Math.random()))*ipsum_words.length
    ipsum_phrase = ipsum_words.slice(0, ipsum_cutoff).join(' ')
  else
    ipsum_phrase = ipsum_sentences[x]


getQuotePhrase = (q_count, quotes)->
  if q_count == quotes.length 
    q_count = 0
    console.log "resetting quotes..."
    for q in quotes 
      q.used = undefined

  while quotes[q_count].used? && quotes[q_count].used != 'true'
    q_count += 1
    if q_count == quotes.length 
      q_count = 0
      console.log "resetting quotes..."
      for q in quotes 
        q.used = undefined

  quote = quotes[q_count]

  quote_words = quote.text.split(' ')

  matches = []
  i = 0

  for word in quote_words
    if i > 1 && i < quote_words.length - 1
      if word in wordList 
        matches.push word
    i+=1

  console.log '\n'
  console.log quote.text
  console.log matches

  q = 0
  
  while q < quotes.length && quote_phrase == undefined
    if q != q_count and quotes[q].used != 'true'
      for w in matches

        test_word = ' '+w+' '

        if quotes[q].text.indexOf(test_word) != -1

          quotes[q_count].used = 'true'
          quotes[q].used = 'true'

          console.log test_word
          console.log quotes[q_count].text.split(test_word)
          console.log quotes[q].text.split(test_word)

          if Math.random() > 0.5
            first_half = quotes[q].text.split(test_word)[0]
            second_half = quotes[q_count].text.split(test_word)[1]
          else
            first_half = quotes[q_count].text.split(test_word)[0]
            second_half = quotes[q].text.split(test_word)[1]
          
          quote_phrase = first_half + test_word + second_half
          console.log "QUOTE_PHRASE: " + quote_phrase
          break
    q++      
  q_count += 1
  {quote_phrase, q_count}


makeParagraphs = (callback, quotes, ipsums, num_paragraphs)->
  paragraphs = []

  while paragraphs.length != num_paragraphs
    paragraph_length = Math.floor avg_paragraph_length + (avg_paragraph_length/2 * (Math.random() - 0.5))
    response = ""
    
    i_count = 0
    q_count = 0

    while response.length < paragraph_length

      ipsum_phrase = undefined
      quote_phrase = undefined

      #get the ipsum portion
      ipsum = ipsums[i_count]
      i_count++
      if i_count >= ipsums.length
        i_count = 0
      ipsum_phrase = getIpsumPhrase ipsum

      #get the quote portion
      {quote_phrase, q_count} = getQuotePhrase q_count, quotes

      #make the response  
      if quote_phrase && ipsum_phrase
        if Math.random() > 0.5
          ipsum_phrase = fixPeriods ipsum_phrase
          response += quote_phrase + '. ' + ipsum_phrase + '. '
        else
          quote_phrase = fixPeriods quote_phrase
          response += ipsum_phrase + '. ' + quote_phrase + '. '

      console.log "RESPONSE: " + response + "\n"
    
    #add to the paragraph
    if response.length > 0
      paragraphs.push response

  callback null, paragraphs


###
  MAKE CALLS TO THE DATABASE
###

getQuotes = (callback)->
  Quote.find (err, quotes) ->
    if err
      callback err
    else
      callback null, quotes

getIpsums = (callback)->
  Ipsum.find (err, ipsums) ->
    if err
      callback err
    else
      callback null, ipsums


###
  SET UP CALLS
###

module.exports = (paragraphs, callback) ->
  
  actions = 
    quotes: (cb) ->
      getQuotes cb

    ipsums: (cb) ->
      getIpsums cb

    shuffleQuotes: ['quotes', (cb, {quotes}) ->
      shuffle cb, quotes
    ]

    shuffleIpsums: ['ipsums', (cb, {ipsums}) ->
      shuffle cb, ipsums
    ]

    paragraphs: ['shuffleQuotes', 'shuffleIpsums', (cb, results) ->
      makeParagraphs cb, results.shuffleQuotes, results.shuffleIpsums, paragraphs
    ]

  async.auto actions, (err, results)->
    if err?
      console.log err
      return err
    else
      callback results
