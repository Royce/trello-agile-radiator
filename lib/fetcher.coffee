Trello = require "node-trello"
asyncblock = require "asyncblock"

class Fetcher
  constructor: (key, token) ->
    @trello = new Trello(key, token)

  # Make a GET request to Trello.
  # Syntax: trello.get(uri, [query], callback)
  fetch: (board) ->
    cards = {}
    asyncblock (flow) ->
      listLookup = flow.future()
      getListLookup board, listLookup

      cardsFuture = flow.future()
      getCards @trello, board, cardsFuture

      cards = cardsFuture.result
      flattenLabels cards
      disectName cards
      disectChecklists cards
      translateListIds cards, listLookup.result
    });

  getListLookup: (board, future) ->
    @trello.get '/1/board/#{board}/lists', { fields: 'name' }, (err, data) ->
      future(err, data) if err

      lookup = {}
      lookup[item.id] = item.name for item in data

      future(err, lookup)

  getCards: (board, future) ->
    details = { fields: 'name,idList,labels', checklists: 'all' }
    @trello.get('/1/board/#{board}/cards', details, future)

module.exports = Fetcher
