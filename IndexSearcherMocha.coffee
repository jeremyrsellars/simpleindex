vows = require 'vows'
assert = require 'assert'

indexSearcher = require './IndexSearcher.coffee'
IndexSearcher = indexSearcher.IndexSearcher

BitArray = require 'bit-array'

index = require './Index.js'
Index = index.Index

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
  IsMatchAtIndex: (index) -> true

class AlternatingQuery
  IsMatchAtIndex: (index) -> index % 2

class MatchLessThanQuery
  constructor: (value) -> @value = value
  IsMatchAtIndex: (index) -> index < @value

class RequiresIndexSearcherQuery
  IsMatchAtIndex: (index,  @searcher) -> 
    assert.instanceOf  @searcher, IndexSearcher
    return

describe 'IndexSearcher', ->
  describe 'Given *new IndexSearcher(EmptyIndex)*' , ->
    describe '*searchAllIndexes*', ->
      it 'yields an *empty* bit array' , (done)->
        searcher = new IndexSearcher EmptyIndex
        searcher.searchAllIndexes AllTermsQuery, (err, hits)->
          assert.deepEqual hits, EmptyBitArray
          done()

  describe 'Given *new IndexSearcher(EightDocIndex)*' , ->
    before (done)->
      @searcher = new IndexSearcher EightDocIndex
      done()
    describe '*searchAllIndexes AllTermsQuery*', (done)->
      it 'yields *8 matches*' , (done)->
        @searcher.searchAllIndexes new (AllTermsQuery), (err, hits)->
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
    describe '*searchAllIndexes RequiresIndexSearcherQuery*', ->
      it '*passes*' , (done)->
        @searcher.searchAllIndexes new (RequiresIndexSearcherQuery), (err, hits)->
          done()
