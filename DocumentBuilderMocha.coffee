require 'should'
assert = require 'assert'

DocumentBuilder = require('./DocumentBuilder.coffee').DocumentBuilder

staticBodyConverter =
  body: (d) -> 'static body text'

staticBodyDocument =
  body: 'static body text'

radiologyConverter =
  type: (d) -> 'radiology'
  body: (d) -> d

buildRadiologyDocument = (body) ->
  'type': 'radiology'
  'body': body

describe 'Given new DocumentBuilder *staticBodyConverter* When building from *null*', -> 
  it 'Is *staticBodyDocument*', ->
    builder = new DocumentBuilder (staticBodyConverter)
    doc = builder.build null
    assert.deepEqual doc, staticBodyDocument

describe "Given new DocumentBuilder *radiologyConverter* When building from *'my cool body'*", -> 
    it 'Is *radiology document*', ->
      builder = new DocumentBuilder (radiologyConverter)
      doc = builder.build 'my cool body'
      assert.deepEqual doc, buildRadiologyDocument 'my cool body'
