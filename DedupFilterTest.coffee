vows = require 'vows'
assert = require 'assert'

dedupFilter = require './DedupFilter.coffee'
DedupFilter = dedupFilter.DedupFilter

apple = ['apple'];
apple = ['apple'];

class ConstantFilter
  constructor: (terms) ->
    if terms? && terms[0]?
      this.terms = terms
    else
      this.terms = []
    return
  filter: (terms) ->
    this.terms

vows.describe('DedupFilter').addBatch(
  'Given *new DedupFilter*': 
    'topic': new DedupFilter
    'Filtering an *empty* term set': 
      'topic': (filter) ->
        return filter.filter []
      'yields an *empty* term set':  (terms) ->
        assert.deepEqual terms, []
    "Filtering *['apple']*": 
      'topic': (filter) ->
        return filter.filter apple
      'yields *that term*':  (terms) ->
        assert.deepEqual terms, apple
    "Filtering *['apple','apple']*": 
      'topic': (filter) ->
        return filter.filter apple
      'yields *lower case*':  (terms) ->
        assert.deepEqual terms, apple
    "Filtering *['apple','PIE','apple']*": 
      'topic': (filter) ->
        return filter.filter ['apple', 'PIE', 'apple']
      "yields *['apple','pie']* set":  (terms) ->
        assert.deepEqual terms, ['apple', 'PIE']
    "Filtering *['apple','PIE','apple']*": 
      'topic': (filter) ->
        return filter.filter ['apple', 'PIE', 'APPLE', 'pie']
      "yields *['apple','pie']* set":  (terms) ->
        assert.deepEqual terms, ['APPLE','PIE','apple','pie']

).addBatch(
  "Given *new DedupFilter(new ConstantFilter(['apple','apple','apple']))*": 
    'topic': new DedupFilter(new ConstantFilter(['apple','apple','apple']))
    'Filtering an *empty* term set': 
      'topic': (filter) ->
        return filter.filter []
      "yields *['apple']*":  (terms) ->
        assert.deepEqual terms, apple
    "Filtering a *['apple']* term": 
      'topic': (filter) ->
        return filter.filter apple
      "yields *['apple']*":  (terms) ->
        assert.deepEqual terms, apple
).export(module)
