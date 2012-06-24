BitArray = require 'bit-array'

class IndexSearcher
  constructor: (index) ->
    @index = index

  searchAllIndexesSync: (query) ->
    b = new BitArray
    if @index.count()
      b.set n, query.IsMatchAtIndex(n, @) for n in [0..@index.count() - 1]
    return b

  searchAllIndexes: (query, callback) ->
    process.nextTick () =>
      x = @searchAllIndexesSync query
      callback null, x
      return
    return

module.exports =
  IndexSearcher : IndexSearcher