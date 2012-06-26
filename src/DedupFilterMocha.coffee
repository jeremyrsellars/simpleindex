require 'should'
assert = require 'assert'

DedupFilter = require('./DedupFilter.coffee').DedupFilter

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

describe 'DedupFilter', ->
  describe 'Given *new DedupFilter*', ->
    before (done)->
      @filter = new DedupFilter
      done()
    describe 'Filtering an *empty* term set', ->
      it 'yields an *empty* term set', ->
        terms = @filter.filter []
        assert.deepEqual terms, []

    describe "Filtering *['apple']*", ->
      it 'yields *that term*', ->
        terms = @filter.filter apple
        assert.deepEqual terms, apple

    describe "Filtering *['apple','apple']*", -> 
      it 'yields *lower case*', ->
        terms = @filter.filter apple
        assert.deepEqual terms, apple
    describe "Filtering *['apple','PIE','apple']*", ->
      it "yields *['PIE', 'apple']* set", ->
        terms = @filter.filter ['apple', 'PIE', 'apple']
        assert.deepEqual terms, ['PIE', 'apple']
    describe "Filtering *['apple','PIE','apple']*", ->
      it "yields *['apple','pie']* set", ->
        terms = @filter.filter ['apple', 'PIE', 'APPLE', 'pie']
        assert.deepEqual terms, ['APPLE','PIE','apple','pie']
  
  describe "Given *new DedupFilter(new ConstantFilter(['apple','apple','apple']))*", ->
    before (done)->
      @filter = new DedupFilter(new ConstantFilter(['apple','apple','apple']))
      done()
    describe 'Filtering an *empty* term set', ->
      it "yields *['apple']*", ->
        terms = @filter.filter []
        assert.deepEqual terms, apple
    describe "Filtering a *['apple']* term", ->
      it "yields *['apple']*", ->
        terms = @filter.filter apple
        assert.deepEqual terms, apple
