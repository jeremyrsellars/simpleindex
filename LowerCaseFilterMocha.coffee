require 'should'
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

describe 'LowerCaseFilter', ->
  describe 'Given *new LowerCaseFilter*', ->
    before (done) ->
      @filter = new LowerCaseFilter
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
      it 'yields *that term*',  ->
        assert.deepEqual @terms, apple
    describe "Filtering *['APPLE']*", ->
      before (done) ->
        @terms = @filter.filter APPLE
        done()
      it 'yields *lower case*', ->
        assert.deepEqual @terms, apple
    describe "Filtering *['APPLE','PIE']*", ->
      before (done) ->
        @terms = @filter.filter ['APPLE', 'PIE']
        done()
      it "yields *['apple','pie']* set",  ->
        assert.deepEqual @terms, ['apple', 'pie']

describe 'LowerCaseFilter', ->
  describe 'Given *new LowerCaseFilter(new ConstantFilter(APPLE))*', ->
    before (done) ->
      @filter = new LowerCaseFilter(new ConstantFilter(APPLE))
      done()
    describe 'Filtering an *empty* term set', ->
      before (done) ->
        @terms = @filter.filter []
        done()
      it "yields *['apple']*", ->
        assert.deepEqual @terms, apple
    describe "Filtering a *['APPLE']* term", ->
      before (done) ->
        @terms = @filter.filter APPLE
        done()
      it "yields *['apple']*", ->
        assert.deepEqual @terms, apple
