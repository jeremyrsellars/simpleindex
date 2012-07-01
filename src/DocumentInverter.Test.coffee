assert = require 'assert'
require 'should'

documentInverter = require './DocumentInverter.coffee'
DocumentInverter = documentInverter.DocumentInverter

brownSquirrelsTaste = 'brown squirrels taste better than red squirrels.';
quickBrownFox = 'the quick brown fox jumped over the lazy dog.';

describe 'Given *new DocumentInverter*', ->
  before (done)->
    @inverter = new DocumentInverter
    done()

  it 'When first initialized', ->
    it 'is a DocumentInverter', ->
      (@inverter instanceof DocumentInverter).should.be.true
    
  describe 'When tokenizing an *empty string - synchronously*', ->
    it 'yields *empty array*', ->
      terms = @inverter.tokenizeSync ''
      assert.deepEqual terms, []
    
  describe 'When tokenizing *" " - synchronously*', ->
    it 'yields *empty array*', ->
      terms = @inverter.tokenizeSync " "
      assert.deepEqual terms, []
    
  describe 'When tokenizing *"a" - synchronously*', ->
    it "yields *['a']*", ->
      terms = @inverter.tokenizeSync "a"
      assert.deepEqual terms, ['a']
    
  describe 'When tokenizing *"b" - synchronously*', ->
    it "yields *['b']*", ->
      terms = @inverter.tokenizeSync "b"
      assert.deepEqual terms, ['b']
    
  describe 'When tokenizing *" a" - synchronously*', ->
    it "yields *['a']*", ->
      terms = @inverter.tokenizeSync ' a'
      assert.deepEqual terms, ['a']
    
  describe 'When tokenizing *"  " - synchronously*', ->
    it 'yields *empty array*', ->
      terms = @inverter.tokenizeSync '  '
      assert.deepEqual terms, []
    
  describe "When tokenizing *'a,.-_!@#$%^&*(),./;\"\'' - synchronously*'", ->
    it "yields *['a']*'", ->
      terms = @inverter.tokenizeSync 'a,.-_!@#$%^&*(),./;\"\''
      assert.deepEqual terms, ['a']
    
  describe "When tokenizing *'a,a' - synchronously*'", ->
    it "yields *['a','a']*'", ->
      terms = @inverter.tokenizeSync 'a,a'
      assert.deepEqual terms, ['a','a']
    
  describe "When tokenizing *'a,b' - synchronously*'", ->
    it "yields *['a','b']*'", ->
      terms = @inverter.tokenizeSync 'a,b'
      assert.deepEqual terms, ['a','b']
    
  describe "When tokenizing *'with spaces, commas, and semicolons; succeeds' - synchronously*'", ->
    it "yields *only words*'", ->
      terms = @inverter.tokenizeSync 'with spaces, commas, and semicolons; succeeds'
      assert.deepEqual terms, ['with','spaces','commas','and','semicolons','succeeds']
    
  describe 'Given *new DocumentInverter*', -> 
    describe 'When inverting {fname:""}- synchronously*', ->
      it 'yields *empty array*', ->
        terms = @inverter.invertSync {fname:""}
        assert.deepEqual terms, []
      
    describe 'When inverting {fname:"apple"}- synchronously*', ->
      it 'yields *["fname:apple"]*', ->
        terms = @inverter.invertSync {fname:"apple"}
        assert.deepEqual terms, ["fname:apple"]
      
    describe 'When inverting {fname:"john", lname:"go"}- synchronously*', ->
      it 'yields *["fname:john", "lname:go"]*', ->
        terms = @inverter.invertSync {fname:"john", lname:"go"}
        assert.deepEqual terms, ["fname:john", "lname:go"]
      
    describe 'When inverting {fname:["john", "johnny be good"], lname:"go"}- synchronously*', ->
      it 'yields *["fname:john", "fname:johnny be good", "lname:go"]*', ->
        terms = @inverter.invertSync {fname:["john", "johnny be good"], lname:"go"}
        assert.deepEqual terms, ["fname:john", "fname:johnny be good", "lname:go"]
