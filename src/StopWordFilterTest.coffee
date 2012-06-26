vows = require 'vows'
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

vows.describe('StopWordFilter').addBatch(
  'Given *new StopWordFilter*': 
    'topic': new StopWordFilter
    'Filtering an *empty* term set': 
      'topic': (filter) ->
        return filter.filter []
      'yields an *empty* term set':  (terms) ->
        assert.deepEqual terms, []
    'Filtering a *single* term': 
      'topic': (filter) ->
        return filter.filter apple
      'yields *that term*':  (terms) ->
        assert.deepEqual terms, apple
    'Filtering *two terms*': 
      'topic': (filter) ->
        return filter.filter aApple
      'yields *same* set':  (terms) ->
        assert.deepEqual terms, aApple
    'Filtering *many terms*': 
      'topic': (filter) ->
        return filter.filter anAppleADayKeepsTheDoctorAway
      'yields *same* set':  (terms) ->
        assert.deepEqual terms, anAppleADayKeepsTheDoctorAway
     
  "Given *new StopWordFilter (['the'])* filter": 
    'topic': new StopWordFilter (['the'])
    'Filtering an *empty* term set': 
      'topic': (filter) ->
        return filter.filter []
      'yields an *empty* term set':  (terms) ->
        assert.deepEqual terms, []
    'Filtering a *single* term': 
      'topic': (filter) ->
        return filter.filter apple
      'yields *that term*':  (terms) ->
        assert.deepEqual terms, apple
    'When *one word is a stop word*': 
      'topic': (filter) ->
        return filter.filter theApple
      'yields *same* set':  (terms) ->
        assert.deepEqual terms, ['apple']
    'Filtering *many terms*': 
      'topic': (filter) ->
        return filter.filter anAppleADayKeepsTheDoctorAway
      "yields no 'the' terms":  (terms) ->
        assert.deepEqual terms, 
          ['an', 'apple', 'a', 'day', 'keeps', 'doctor', 'away']
    
  "Given *new StopWordFilter (['a', 'an', 'the'])*": 
    'topic': new StopWordFilter (['a', 'an', 'the'])
    'Filtering an *empty* term set': 
      'topic': (filter) ->
        return filter.filter []
      'yields an *empty* term set':  (terms) ->
        assert.deepEqual terms, []
    'Filtering a *single* term': 
      'topic': (filter) ->
        return filter.filter apple
      'yields *that term*':  (terms) ->
        assert.deepEqual terms, apple
    'When *one word is a stop word*': 
      'topic': (filter) ->
        return filter.filter theApple
      'yields *same* set':  (terms) ->
        assert.deepEqual terms, ['apple']
    'Filtering *many terms*': 
      'topic': (filter) ->
        return filter.filter anAppleADayKeepsTheDoctorAway
      'yields no articles set':  (terms) ->
        assert.deepEqual terms, 
          ['apple', 'day', 'keeps', 'doctor', 'away']
).addBatch(
  'Given *new StopWordFilter([], new ConstantFilter(anApple))*': 
    'topic': new StopWordFilter([], new ConstantFilter(anApple))
    'Filtering an *empty* term set': 
      'topic': (filter) ->
        return filter.filter []
      'yields *an apple*':  (terms) ->
        assert.deepEqual terms, anApple
    'Filtering a *single* term': 
      'topic': (filter) ->
        return filter.filter apple
      'yields *an apple*':  (terms) ->
        assert.deepEqual terms, anApple
    'Filtering *two terms*': 
      'topic': (filter) ->
        return filter.filter aApple
      'yields *an apple*':  (terms) ->
        assert.deepEqual terms, anApple
    'Filtering *many terms*': 
      'topic': (filter) ->
        return filter.filter anAppleADayKeepsTheDoctorAway
      'yields *an apple*':  (terms) ->
        assert.deepEqual terms, anApple
     
  "Given *StopWordFilter ['the'], new ConstantFilter(anAppleADayKeepsTheDoctorAway)*": 
    'topic': 
      new StopWordFilter ['the'], new ConstantFilter(anAppleADayKeepsTheDoctorAway)
    'Filtering an *empty* term set': 
      'topic': (filter) ->
        return filter.filter []
      "yields no 'the' terms":  (terms) ->
        assert.deepEqual terms, 
          ['an', 'apple', 'a', 'day', 'keeps', 'doctor', 'away']
    'Filtering a *single* term': 
      'topic': (filter) ->
        return filter.filter apple
      "yields no 'the' terms":  (terms) ->
        assert.deepEqual terms, 
          ['an', 'apple', 'a', 'day', 'keeps', 'doctor', 'away']
    'When *one word is a stop word*': 
      'topic': (filter) ->
        return filter.filter theApple
      "yields no 'the' terms":  (terms) ->
        assert.deepEqual terms, 
          ['an', 'apple', 'a', 'day', 'keeps', 'doctor', 'away']
    'Filtering *many terms*': 
      'topic': (filter) ->
        return filter.filter anAppleADayKeepsTheDoctorAway
      "yields no 'the' terms":  (terms) ->
        assert.deepEqual terms, 
          ['an', 'apple', 'a', 'day', 'keeps', 'doctor', 'away']
    
  "Given *StopWordFilter ['a', 'an', 'the'], new ConstantFilter anAppleADayKeepsTheDoctorAway*": 
    'topic': 
      new StopWordFilter ['a', 'an', 'the'], new ConstantFilter anAppleADayKeepsTheDoctorAway
    'Filtering an *empty* term set': 
      'topic': (filter) ->
        return filter.filter []
      'yields no articles':  (terms) ->
        assert.deepEqual terms, 
          ['apple', 'day', 'keeps', 'doctor', 'away']
    'Filtering a *single* term': 
      'topic': (filter) ->
        return filter.filter apple
      'yields no articles':  (terms) ->
        assert.deepEqual terms, 
          ['apple', 'day', 'keeps', 'doctor', 'away']
    'When *one word is a stop word*': 
      'topic': (filter) ->
        return filter.filter theApple
      'yields no articles':  (terms) ->
        assert.deepEqual terms, 
          ['apple', 'day', 'keeps', 'doctor', 'away']
    'Filtering *many terms*': 
      'topic': (filter) ->
        return filter.filter anAppleADayKeepsTheDoctorAway
      'yields no articles':  (terms) ->
        assert.deepEqual terms, 
          ['apple', 'day', 'keeps', 'doctor', 'away']
).export(module)
