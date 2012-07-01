require 'should'
assert = require 'assert'

prefixFilter = require './PrefixFilter.coffee'
PrefixFilter = prefixFilter.PrefixFilter

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

describe 'PrefixFilter', ->
  describe 'Given *new PrefixFilter("field:")*', ->
    before (done) ->
      @filter = new PrefixFilter("field:")
      done()
    describe 'Filtering an *empty* term set', ->
      before (done) ->
        @terms = @filter.filter []
        done()
      it 'yields an *empty* term set', ->
        assert.deepEqual @terms, []
    describe "Filtering *['apple']*", ->
      before (done) ->
        @terms = @filter.filter apple
        done()
      it "yields *['field:apple']*", ->
        assert.deepEqual @terms, ['field:apple']
    describe "Filtering *['apple','pie']*", ->
      before (done) ->
        @terms = @filter.filter ['apple', 'pie']
        done()
      it "yields *['field:apple','field:pie']* set",  ->
        assert.deepEqual @terms, ['field:apple','field:pie']

describe 'PrefixFilter', ->
  describe 'Given *new PrefixFilter("fieldName:", new ConstantFilter(apple))*', ->
    before (done) ->
      @filter = new PrefixFilter("fieldName:", new ConstantFilter(apple))
      done()
    describe 'Filtering an *empty* term set', ->
      before (done) ->
        @terms = @filter.filter []
        done()
      it "yields *['fieldName:apple']*", ->
        assert.deepEqual @terms, ['fieldName:apple']
    describe "Filtering a *['apple']* term", ->
      before (done) ->
        @terms = @filter.filter apple
        done()
      it "yields *['fieldName:apple']*", ->
        assert.deepEqual @terms, ['fieldName:apple']
