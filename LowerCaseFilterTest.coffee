vows = require 'vows'
assert = require 'assert'

lowerCaseFilter = require './LowerCaseFilter.coffee'
LowerCaseFilter = lowerCaseFilter.LowerCaseFilter

apple = ['apple'];
APPLE = ['APPLE'];

orange = ['orange'];
ORANGE = ['ORANGE'];

class ConstantFilter
  constructor: (terms) ->
    if terms? && terms[0]?
      this.terms = terms
    else
      this.terms = []
    return
  filter: (terms) ->
    this.terms

vows.describe('LowerCaseFilter').addBatch(
  'Given *new LowerCaseFilter*': 
    'topic': new LowerCaseFilter
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
    "Filtering *['APPLE']*": 
      'topic': (filter) ->
        return filter.filter APPLE
      'yields *lower case*':  (terms) ->
        assert.deepEqual terms, apple
    "Filtering *['APPLE','PIE']*": 
      'topic': (filter) ->
        return filter.filter ['APPLE', 'PIE']
      "yields *['apple','pie']* set":  (terms) ->
        assert.deepEqual terms, ['apple', 'pie']

).addBatch(
  'Given *new LowerCaseFilter(new ConstantFilter(APPLE))*': 
    'topic': new LowerCaseFilter(new ConstantFilter(APPLE))
    'Filtering an *empty* term set': 
      'topic': (filter) ->
        return filter.filter []
      "yields *['apple']*":  (terms) ->
        assert.deepEqual terms, apple
    "Filtering a *['APPLE']* term": 
      'topic': (filter) ->
        return filter.filter APPLE
      "yields *['apple']*":  (terms) ->
        assert.deepEqual terms, apple
).export(module)
