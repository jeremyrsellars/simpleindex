require 'should'
assert = require 'assert'

stopWordFilter = require './StopWordFilter.coffee'
StopWordFilter = stopWordFilter.StopWordFilter

apple = ['apple'];
aApple = ['a','apple'];
anApple = ['an','apple'];
theApple = ['the','apple'];
anAppleADayKeepsTheDoctorAway = [
  'an', 'apple', 'a', 'day', 
  'keeps', 'the', 'doctor', 'away'];

ConstantFilter = (terms) ->
  if terms? && terms[0]?
    this.terms = terms
  else
    this.terms = []
  return

ConstantFilter.prototype.filter = (terms) ->
  this.terms

describe 'StopWordFilter', ->
  describe 'Given *new StopWordFilter*', ->
    before (done) ->
      @filter = new StopWordFilter()
      done()
    
    describe 'Filtering an *empty* term set', ->
      before (done) ->
        @terms = @filter.filter []
        done()
      it 'yields an *empty* term set', ->
        assert.deepEqual @terms, []
    describe 'Filtering a *single* term', -> 
      before (done) ->
        @terms = @filter.filter apple
        done()
      it 'yields *that term*', ->
        assert.deepEqual @terms, apple
    describe 'Filtering *two terms*', -> 
      before (done) ->
        @terms = @filter.filter aApple
        done()
      it 'yields *same* set', ->
        assert.deepEqual @terms, aApple
    describe 'Filtering *many terms*', -> 
      before (done) ->
        @terms = @filter.filter anAppleADayKeepsTheDoctorAway
        done()
      it 'yields *same* set', ->
        assert.deepEqual @terms, anAppleADayKeepsTheDoctorAway
     
  describe "Given *new StopWordFilter (['the'])* filter", -> 
    before (done) ->
      @filter = new StopWordFilter (['the'])
      done()
    describe 'Filtering an *empty* term set', -> 
      before (done) ->
        @terms = @filter.filter []
        done()
      it 'yields an *empty* term set', ->
        assert.deepEqual @terms, []
    describe 'Filtering a *single* term', -> 
      before (done) ->
        @terms = @filter.filter apple
        done()
      it 'yields *that term*', ->
        assert.deepEqual @terms, apple
    describe 'When *one word is a stop word*', -> 
      before (done) ->
        @terms = @filter.filter theApple
        done()
      it 'yields *same* set', ->
        assert.deepEqual @terms, ['apple']
    describe 'Filtering *many terms*', -> 
      before (done) ->
        @terms = @filter.filter anAppleADayKeepsTheDoctorAway
        done()
      it "yields no 'the' terms", ->
        assert.deepEqual @terms, 
          ['an', 'apple', 'a', 'day', 'keeps', 'doctor', 'away']
    
  describe "Given *new StopWordFilter (['a', 'an', 'the'])*", -> 
    before (done) -> 
      @filter = new StopWordFilter (['a', 'an', 'the'])
      done()
    describe 'Filtering an *empty* term set', -> 
      before (done) ->
        @terms = @filter.filter []
        done()
      it 'yields an *empty* term set', ->
        assert.deepEqual @terms, []
    describe 'Filtering a *single* term', -> 
      before (done) ->
        @terms = @filter.filter apple
        done()
      it 'yields *that term*', ->
        assert.deepEqual @terms, apple
    describe 'When *one word is a stop word*', -> 
      before (done) ->
        @terms = @filter.filter theApple
        done()
      it 'yields *same* set', ->
        assert.deepEqual @terms, ['apple']
    describe 'Filtering *many terms*', -> 
      before (done) ->
        @terms = @filter.filter anAppleADayKeepsTheDoctorAway
        done()
      it 'yields no articles set', ->
        assert.deepEqual @terms, 
          ['apple', 'day', 'keeps', 'doctor', 'away']

  describe 'Given *new StopWordFilter([], new ConstantFilter(anApple))*', -> 
    before (done) ->
      @filter = new StopWordFilter([], new ConstantFilter(anApple))
      done()
    describe 'Filtering an *empty* term set', -> 
      before (done) ->
        @terms = @filter.filter []
        done()
      it 'yields *an apple*', ->
        assert.deepEqual @terms, anApple
    describe 'Filtering a *single* term', -> 
      before (done) ->
        @terms = @filter.filter apple
        done()
      it 'yields *an apple*', ->
        assert.deepEqual @terms, anApple
    describe 'Filtering *two terms*', -> 
      before (done) ->
        @terms = @filter.filter aApple
        done()
      it 'yields *an apple*', ->
        assert.deepEqual @terms, anApple
    describe 'Filtering *many terms*', -> 
      before (done) ->
        @terms = @filter.filter anAppleADayKeepsTheDoctorAway
        done()
      it 'yields *an apple*', ->
        assert.deepEqual @terms, anApple
     
  describe "Given *StopWordFilter ['the'], new ConstantFilter(anAppleADayKeepsTheDoctorAway)*", -> 
    before (done) -> 
      @filter = new StopWordFilter ['the'], new ConstantFilter(anAppleADayKeepsTheDoctorAway)
      done()
    describe 'Filtering an *empty* term set', -> 
      before (done) ->
        @terms = @filter.filter []
        done()
      it "yields no 'the' terms", ->
        assert.deepEqual @terms, 
          ['an', 'apple', 'a', 'day', 'keeps', 'doctor', 'away']
    describe 'Filtering a *single* term', -> 
      before (done) ->
        @terms = @filter.filter apple
        done()
      it "yields no 'the' terms", ->
        assert.deepEqual @terms, 
          ['an', 'apple', 'a', 'day', 'keeps', 'doctor', 'away']
    describe 'When *one word is a stop word*', -> 
      before (done) ->
        @terms = @filter.filter theApple
        done()
      it "yields no 'the' terms", ->
        assert.deepEqual @terms, 
          ['an', 'apple', 'a', 'day', 'keeps', 'doctor', 'away']
    describe 'Filtering *many terms*', -> 
      before (done) ->
        @terms = @filter.filter anAppleADayKeepsTheDoctorAway
        done()
      it "yields no 'the' terms", ->
        assert.deepEqual @terms, 
          ['an', 'apple', 'a', 'day', 'keeps', 'doctor', 'away']
    
  describe "Given *StopWordFilter ['a', 'an', 'the'], new ConstantFilter anAppleADayKeepsTheDoctorAway*", -> 
    before (done) -> 
      @filter = new StopWordFilter ['a', 'an', 'the'], new ConstantFilter anAppleADayKeepsTheDoctorAway
      done()
    describe 'Filtering an *empty* term set', -> 
      before (done) ->
        @terms = @filter.filter []
        done()
      it 'yields no articles', ->
        assert.deepEqual @terms, 
          ['apple', 'day', 'keeps', 'doctor', 'away']
    describe 'Filtering a *single* term', -> 
      before (done) ->
        @terms = @filter.filter apple
        done()
      it 'yields no articles', ->
        assert.deepEqual @terms, 
          ['apple', 'day', 'keeps', 'doctor', 'away']
    describe 'When *one word is a stop word*', -> 
      before (done) ->
        @terms = @filter.filter theApple
        done()
      it 'yields no articles', ->
        assert.deepEqual @terms, 
          ['apple', 'day', 'keeps', 'doctor', 'away']
    describe 'Filtering *many terms*', -> 
      before (done) ->
        @terms = @filter.filter anAppleADayKeepsTheDoctorAway
        done()
      it 'yields no articles', ->
        assert.deepEqual @terms, 
          ['apple', 'day', 'keeps', 'doctor', 'away']
