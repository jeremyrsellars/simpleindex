BitArray = require 'bit-array'

class module.exports.IndexSearcher
  constructor: (index) ->
    @index = index

  searchAllIndexesSync: (query) ->
    query.search @index

  searchAllIndexes: (query, callback) ->
    process.nextTick () =>
      x = @searchAllIndexesSync query
      callback null, x
      return
    return
