_ = require "underscore"
Trello = require "node-trello"
asyncblock = require "asyncblock"

Card = require "./card"

class Fetcher
  constructor: (key, token) ->
    @trello = new Trello(key, token)

  fetch: (board) ->
    cards = {}
    asyncblock (flow) =>
      listLookupFuture = flow.future()
      @getListLookup board, listLookupFuture

      cardsFuture = flow.future()
      @getCards board, cardsFuture

      cards =
      _(cardsFuture.result)
      .map (card) ->
        new Card(card, { listLookup: listLookupFuture.result })

      flow.wait()
    cards

  getListLookup: (board, future) ->
    @trello.get '/1/boards/#{board}/lists',
      fields: 'name'
      (err, data) ->
        return future(err, data) if err

        lookup = {}
        lookup[item.id] = item.name for item in data

        future(err, lookup)

  getCards: (board, future) ->
    @trello.get '/1/boards/#{board}/cards',
      fields: 'name,idList,labels'
      checklists: 'all'
      , future

module.exports = Fetcher
