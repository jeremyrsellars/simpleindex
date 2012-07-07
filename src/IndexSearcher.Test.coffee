assert = require 'assert'

IndexSearcher = require('./IndexSearcher.coffee').IndexSearcher

BitArray = require 'bit-array'

Index = require('./Index.coffee').Index

EmptyIndex = new Index
EmptyBitArray = new BitArray

EightDocIndex = new Index
EightDocIndex.addSync '', [] for n in [0..7]
EightMatchesBitArray = new BitArray
EightMatchesBitArray.set n, 1 for n in [0..7]
AlternatingBitArray = new BitArray
AlternatingBitArray.set n, 1 for n in [1..7] by 2
First4OnBitArray = new BitArray
First4OnBitArray.set n, 1 for n in [0..3]

class AllTermsQuery
  search: (index) ->
    b = new BitArray()
    count = index.count()
    b.set n, 1 for n in [0...count] if count
    b

class AlternatingQuery
  search: (index) ->
    b = new BitArray()
    count = index.count()
    b.set n, n % 2 for n in [0...count] if count
    b

class MatchLessThanQuery
  constructor: (@value) ->
    return
  search: (index) ->
    b = new BitArray()
    count = index.count()
    b.set n, n < @value for n in [0...count] if count
    b

describe 'IndexSearcher', ->
  describe 'Given *new IndexSearcher(EmptyIndex)*' , ->
    describe '*searchAllIndexes*', ->
      it 'yields an *empty* bit array' , (done)->
        searcher = new IndexSearcher EmptyIndex
        searcher.searchAllIndexes new AllTermsQuery, (err, hits)->
          assert.deepEqual hits, EmptyBitArray
          done()
  describe 'Given *new IndexSearcher(EightDocIndex)*' , ->
    before (done)->
      @searcher = new IndexSearcher EightDocIndex
      done()
    describe '*searchAllIndexes AllTermsQuery*', (done)->
      it 'yields *8 matches*' , (done)->
        @searcher.searchAllIndexes new AllTermsQuery, (err, hits)->
          assert.deepEqual hits, EightMatchesBitArray
          done()
    describe '*searchAllIndexes MatchLessThanQuery 4*', ->
      it 'yields *first 4 matches*' , (done)->
        @searcher.searchAllIndexes new (MatchLessThanQuery)(4), (err, hits)->
          assert.deepEqual hits, First4OnBitArray
          done()
    describe '*searchAllIndexes AlternatingQuery*', ->
      it 'yields *4 alternating matches*' , (done)->
        @searcher.searchAllIndexes new (AlternatingQuery), (err, hits)->
          assert.deepEqual hits, AlternatingBitArray
          done()
