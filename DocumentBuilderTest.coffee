vows = require 'vows'
assert = require 'assert'

documentBuilder = require './DocumentBuilder.coffee'
DocumentBuilder = documentBuilder.DocumentBuilder

brownSquirrelsTaste = 'brown squirrels taste better than red squirrels.';
quickBrownFox = 'the quick brown fox jumped over the lazy dog.';

staticBodyConverter =
  body: (d) -> 'static body text'

staticBodyDocument =
  body: 'static body text'

staticBodyBuilder = () ->
  new DocumentBuilder (@staticBodyConverter)

radiologyConverter =
  type: (d) -> 'radiology'
  body: (d) -> d

buildRadiologyDocument = (body) ->
  'type': 'radiology'
  'body': body

radiologyBuilder = () ->
  new DocumentBuilder (@radiologyConverter)

suite = vows.describe('DocumentBuilder')

suite.addBatch
  'Given new DocumentBuilder *staticBodyConverter*': 
    'topic': ()->
      runThisFucntion(@callback)
    'is a DocumentBuilder':  (builder) ->
      assert.instanceOf builder, DocumentBuilder
    'When building from *null*': 
      'topic': (builder) -> builder.build null
      'Is *staticBodyDocument*':  (doc) ->
        assert.deepEqual doc, staticBodyDocument

suite.addBatch
  'Given new DocumentBuilder *radiologyConverter*': 
    'topic': new DocumentBuilder (radiologyConverter)
    "When building from *'my cool body'*": 
      'topic': (builder) -> builder.build 'my cool body'
      'Is *radiology document*':  (doc) ->
        assert.deepEqual doc, buildRadiologyDocument 'my cool body'
suite.export(module)
