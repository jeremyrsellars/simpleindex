assert = require 'assert'

Query = require('./Query.coffee').Query

BitArray = require 'bit-array'

Index = require('./Index.coffee').Index

EmptyIndex = new Index

AlternatingBitArray = new BitArray
AlternatingBitArray.set n, 1 for n in [1..7] by 2

describe 'Query', ->
  describe 'Given *new Query(idx -> AlternatingBitArray)*' , ->
    describe '*search*', ->
      it 'yields AlternatingBitArray' , (done)->
        q = new Query (idx) -> AlternatingBitArray
        hits = q.search(EmptyIndex)
        assert.deepEqual hits, AlternatingBitArray
        done()
