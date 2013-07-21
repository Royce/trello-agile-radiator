_ = require "underscore"
Trello = require "node-trello"
asyncblock = require "asyncblock"

Card = require "card"

class Fetcher
  constructor: (key, token) ->
    @trello = new Trello(key, token)

  # Make a GET request to Trello.
  # Syntax: trello.get(uri, [query], callback)
  fetch: (board) ->
    cards = {}
    asyncblock (flow) ->
      listLookupFuture = flow.future()
      getListLookup board, listLookupFuture

      cardsFuture = flow.future()
      getCards board, cardsFuture

      cards =
      _(cardsFuture.result)
      .map (card) ->
        new Card(card, { listLookup: listLookup.result })
    cards

  getListLookup: (board, future) ->
    @trello.get '/1/board/#{board}/lists',
      fields: 'name'
      (err, data) ->
        return future(err, data) if err

        lookup = {}
        lookup[item.id] = item.name for item in data

        future(err, lookup)

  getCards: (board, future) ->
    @trello.get '/1/board/#{board}/cards',
      fields: 'name,idList,labels'
      checklists: 'all'
      , future

module.exports = Fetcher
