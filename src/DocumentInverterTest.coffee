vows = require 'vows'
assert = require 'assert'

documentInverter = require './DocumentInverter.coffee'
DocumentInverter = documentInverter.DocumentInverter

brownSquirrelsTaste = 'brown squirrels taste better than red squirrels.';
quickBrownFox = 'the quick brown fox jumped over the lazy dog.';

vows.describe('DocumentInverter').addBatch(
  'Given *new DocumentInverter*': 
    'topic': new DocumentInverter
    'When first initialized': 
      'is a DocumentInverter':  (inverter) ->
        assert.instanceOf inverter, DocumentInverter
      
    'When tokenizing an *empty string - synchronously*':
      'topic': (inverter) ->
        inverter.tokenizeSync ''
      'yields *empty array*': (terms) ->
        assert.deepEqual terms, []
      
    'When tokenizing *" " - synchronously*':
      'topic': (inverter) ->
        inverter.tokenizeSync " "
     'yields *empty array*': (terms) ->
        assert.deepEqual terms, []
      
    'When tokenizing *"a" - synchronously*':
      'topic': (inverter) ->
        return inverter.tokenizeSync "a"
      "yields *['a']*": (terms) ->
        assert.deepEqual terms, ['a']
      
    'When tokenizing *"b" - synchronously*':
      'topic': (inverter) ->
        return inverter.tokenizeSync "b"
      "yields *['b']*": (terms) ->
        assert.deepEqual terms, ['b']
      
    'When tokenizing *" a" - synchronously*':
      topic: (inverter) ->
        inverter.tokenizeSync ' a'
      "yields *['a']*": (terms) ->
        assert.deepEqual terms, ['a']
      
    'When tokenizing *"  " - synchronously*':
      topic: (inverter) ->
        inverter.tokenizeSync '  '
      'yields *empty array*': (terms) ->
        assert.deepEqual terms, []
      
    "When tokenizing *'a,.-_!@#$%^&*(),./;\"\'' - synchronously*'":
      topic: (inverter) ->
        inverter.tokenizeSync 'a,.-_!@#$%^&*(),./;\"\''
      "yields *['a']*'": (terms) ->
        assert.deepEqual terms, ['a']
      
    "When tokenizing *'a,a' - synchronously*'":
      topic: (inverter) ->
        inverter.tokenizeSync 'a,a'
      "yields *['a','a']*'": (terms) ->
        assert.deepEqual terms, ['a','a']
      
    "When tokenizing *'a,b' - synchronously*'":
      topic: (inverter) ->
        inverter.tokenizeSync 'a,b'
      "yields *['a','b']*'": (terms) ->
        assert.deepEqual terms, ['a','b']
      
    "When tokenizing *'with spaces, commas, and semicolons; succeeds' - synchronously*'":
      topic: (inverter) ->
        inverter.tokenizeSync 'with spaces, commas, and semicolons; succeeds'
      "yields *only words*'": (terms) ->
        assert.deepEqual terms, ['with','spaces','commas','and','semicolons','succeeds']
      
).addBatch(
  'Given *new DocumentInverter*': 
    'topic': new DocumentInverter
    'When inverting an *empty string - synchronously*':
      'topic': (inverter) ->
        inverter.invertSync ''
      'yields *empty array*': (terms) ->
        assert.deepEqual terms, []
      
    'When inverting *" " - synchronously*':
      'topic': (inverter) ->
        inverter.invertSync " "
     'yields *empty array*': (terms) ->
        assert.deepEqual terms, []
      
    'When inverting *"a" - synchronously*':
      'topic': (inverter) ->
        return inverter.invertSync "a"
      "yields *['a']*": (terms) ->
        assert.deepEqual terms, ['a']
      
    'When inverting *"b" - synchronously*':
      'topic': (inverter) ->
        return inverter.invertSync "b"
      "yields *['b']*": (terms) ->
        assert.deepEqual terms, ['b']
      
    'When inverting *" a" - synchronously*':
      topic: (inverter) ->
        inverter.invertSync ' a'
      "yields *['a']": (terms) ->
        assert.deepEqual terms, ['a']
      
    'When inverting *"  " - synchronously*':
      topic: (inverter) ->
        inverter.invertSync '  '
      'yields *empty array*': (terms) ->
        assert.deepEqual terms, []
      
    "When inverting *'a,.-_!@#$%^&*(),./;\"\'' - synchronously*'":
      topic: (inverter) ->
        inverter.invertSync 'a,.-_!@#$%^&*(),./;\"\''
      "yields *['a']*'": (terms) ->
        assert.deepEqual terms, ['a']
      
    "When inverting *'a,a' - synchronously*'":
      topic: (inverter) ->
        inverter.invertSync 'a,a'
      "yields *['a']*'": (terms) ->
        assert.deepEqual terms, ['a']
      
    "When inverting *'a,b' - synchronously*'":
      topic: (inverter) ->
        inverter.invertSync 'a,b'
      "yields *['a','b']*'": (terms) ->
        assert.deepEqual terms, ['a','b']
      
    "When inverting *'with spaces, commas, and semicolons; succeeds' - synchronously*'":
      topic: (inverter) ->
        inverter.invertSync 'with spaces, commas, and semicolons; succeeds'
      "yields *words sorted alphabetically*'": (terms) ->
        assert.deepEqual terms, ['and','commas','semicolons','spaces','succeeds','with']
).export(module)
