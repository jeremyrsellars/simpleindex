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
  IsMatchAtIndex: (index, searcher) -> 
    assert.instanceOf searcher, IndexSearcher
    return

vows.describe('IndexSearcher').addBatch
  'Given *new IndexSearcher(EmptyIndex)*': 
    'topic': new IndexSearcher EmptyIndex
    '*searchAllIndexes*':
      'topic': (searcher) ->
        searcher.searchAllIndexes AllTermsQuery, @callback
        return
      'yields an *empty* bit array': (hits) ->
        assert.deepEqual hits, EmptyBitArray

  'Given *new IndexSearcher(EightDocIndex)*': 
    'topic': new IndexSearcher EightDocIndex
    '*searchAllIndexes AllTermsQuery*':
      'topic': (searcher) ->
        searcher.searchAllIndexes new (AllTermsQuery), @callback
        return
      'yields *8 matches*': (hits) ->
        assert.deepEqual hits, EightMatchesBitArray
    '*searchAllIndexes MatchLessThanQuery 4*':
      'topic': (searcher) ->
        searcher.searchAllIndexes new (MatchLessThanQuery)(4), @callback
        return
      'yields *first 4 matches*': (hits) ->
        assert.deepEqual hits, First4OnBitArray
    '*searchAllIndexes AlternatingQuery*':
      'topic': (searcher) ->
        searcher.searchAllIndexes new (AlternatingQuery), @callback
        return
      'yields *4 alternating matches*': (hits) ->
        assert.deepEqual hits, AlternatingBitArray
    '*searchAllIndexes RequiresIndexSearcherQuery*':
      'topic': (searcher) ->
        searcher.searchAllIndexes new (RequiresIndexSearcherQuery), @callback
        return
      '*passes*': (hits) ->
        #assert.deepEqual hits, EmptyBitArray
.export(module)
