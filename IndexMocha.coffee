assert = require 'assert'
require 'should'

BitArray = require 'bit-array'

simpleindex = require './simple-index'
Index = simpleindex.Index
DocumentInverter = simpleindex.DocumentInverter

brownSquirrelsTaste = 'brown squirrels taste better than red squirrels.';
quickBrownFox = 'the quick brown fox jumped over the lazy dog.';

parseTerm = (s) ->
  if s instanceof Array
    return (parseTerm term for term in s)
  if typeof s == 'string'
    i = s.indexOf ':'
    if i >= 0
      field = s.substring 0, i
      term = s.substring i + 1
      return field:field, term:term
    return field:null, term:term
  throw 'expected string or array of strings.'

describe 'Simple Index: Index', ->
  describe 'An empty index', ->
    before ->
      @index = new Index
    it 'is empty', ->
      assert.equal @index.count(), 0

    describe 'when first document is added *synchronously*', ->
      before (done)->
        terms = parseTerm ['brown', 'red']
        @idx = @index.addSync brownSquirrelsTaste, terms
        done()
        
      it 'returns 0', ->
        assert.equal @idx, 0
      
      it 'getItem *synchronously* yields the item', ->
        assert.equal (@index.getItemSync (@idx)), brownSquirrelsTaste

  describe 'An index with 1 document', -> 
    before (done) -> 
      @index = new Index
      @idx = @index.addSync brownSquirrelsTaste, ['brown', 'red']
      done()

    it 'When getItem *asynchronously*', ->
      before (done)->
        @index.getItem @idx, (err, @result) => done err
      it 'Calls back with Item', ->
        assert.isNull err
        assert.equal @result, brownSquirrelsTaste

    describe 'when second document is added *asynchronously*', ->
      before (done) ->
        @index.add quickBrownFox, ['quick', 'brown', 'lazy'], 
          (err, @index, @docNum) => done err
        
      it 'documentNumber is 1', ->
        assert.equal @docNum, 1
      
      it 'count is 2', ->
        assert.equal @index.count(), 2
      
      it '*getItem* calls back with the item', -> 
        assert.equal (@index.getItemSync (@docNum)), quickBrownFox
      
      describe 'When *getItem*', ->
        before (done) ->
          @index.getItem @docNum, (err, index, @item) => done err
        it 'Item is the result', ->
          assert.deepEqual @item, quickBrownFox

  describe 'when *no documents*.getTermsSync', -> 
    before (done) -> 
      @terms = (new Index).getTermsSync()
      done()
    it 'result is array', ->
      Array.isArray(@terms).should.be.true
    it 'there are no terms', ->
      assert.deepEqual @terms, []

  describe 'when *no documents*.getTermsSync', -> 
    before (done) ->
      @terms = (new Index).getTermsSync()
      done()
    it 'result is array' , ->
      Array.isArray(@terms).should.be.true
    it 'there are no terms' , ->
      assert.deepEqual @terms, []

  describe 'when *one termless document*.getTermsSync', -> 
    before (done) ->
      index = new Index()
      index.addSync '', []
      @terms = index.getTermsSync()
      done()
    it 'there are no terms' , ->
      assert.deepEqual @terms, []

  describe 'when *one one-term document*.getTermsSync', -> 
    before (done) ->
      index = new Index()
      index.addSync 'oneTerm', ['oneTerm']
      @terms = index.getTermsSync()
      done()
    it 'there is *one term*', ->
      toneTerm = 
        field: null
        term: 'oneTerm'
      assert.deepEqual @terms, [toneTerm]

  describe 'when *one two-term document*.getTermsSync', -> 
    before (done) -> 
      index = new Index()
      index.addSync 'two terms', ['two', 'terms']
      @terms = index.getTermsSync()
      done()
    it 'terms are sorted and there are *two terms*', -> 
      tterms = 
        field: null
        term: 'terms'
      ttwo = 
        field: null
        term: 'two'
      assert.deepEqual @terms, [tterms, ttwo]

  describe 'when *one three-term document*.getTermsSync', -> 
    before (done) ->
      index = new Index()
      index.addSync 'only two terms', ['only', 'two', 'terms']
      @terms = index.getTermsSync()
      done()
    it 'terms are sorted and there are *two terms*', ->
      tonly = 
        field: null
        term: 'only'
      tterms = 
        field: null
        term: 'terms'
      ttwo = 
        field: null
        term: 'two'
      assert.deepEqual @terms, [tonly, tterms, ttwo]

  describe 'when *two documents contain same term*.getTermsSync', ->
    before (done) ->
      index = new Index()
      index.addSync 'two terms', ['two', 'terms']
      index.addSync 'two terms', ['two', 'terms']
      @terms = index.getTermsSync()
      done()
    it 'terms are sorted and there are *two terms*', ->
      tterms = 
        field: null
        term: 'terms'
      ttwo = 
        field: null
        term: 'two'
      assert.deepEqual @terms, [tterms, ttwo]

  describe 'when *one one-term document*.getTerms', ->
    before (done) ->
      index = new Index()
      index.addSync 'oneTerm', ['oneTerm']
      index.getTerms (err, @terms) => done err
    it 'there is *oneterm*', ->
      toneTerm = 
        field: null
        term: 'oneTerm'
      assert.deepEqual @terms, [toneTerm]

  describe 'when *empty index*.getIndexesForTermSync', ->
    before (done) ->
      index = new Index()
      @masks = index.getIndexesForTermSync 'term'
      done()
    it 'the mask is *[0]*', ->
      assert.deepEqual @masks, new BitArray()

  describe 'when *yes index*.getIndexesForTermSync (no)', ->
    before (done) ->
      index = new Index()
      index.addSync 'yes', ['yes']
      @masks = index.getIndexesForTermSync 'no'
      done()
    it 'there are *no matches*', ->
      assert.deepEqual @masks, new BitArray(0)

  describe 'when *yes index*.getIndexesForTermSync (yes)', ->
    before (done) ->
      index = new Index()
      index.addSync 'yes', ['yes']
      @masks = index.getIndexesForTermSync 'yes'
      done()
    it 'the *first document matches*', ->
      a = new BitArray();
      a.set 0, true
      assert.deepEqual @masks, a

  describe 'when *empty index*.getIndexesForTermSync', ->
    before (done) ->
      index = new Index()
      @masks = index.getIndexesForTermSync 'term'
      done()
    it 'there are *no matches*', ->
      assert.deepEqual @masks, new BitArray()

  describe 'when *yes no index*.getIndexesForTermSync (yes)', ->
    before (done) ->
      index = new Index()
      index.addSync 'yes', ['yes']
      index.addSync 'no', ['no']
      @masks = index.getIndexesForTermSync 'yes'
      done()
    it 'the *first document matches*', ->
      a = new BitArray();
      a.set 0, true
      assert.deepEqual @masks, a

  describe 'when *yes no yes index*.getIndexesForTermSync (yes)', ->
    before (done) ->
      index = new Index()
      index.addSync 'yes', ['yes']
      index.addSync 'no', ['no']
      index.addSync 'yes', ['yes']
      @masks = index.getIndexesForTermSync 'yes'
      done()
    it 'the *first and third document matches*', ->
      a = new BitArray();
      a.set 0, true
      a.set 2, true
      assert.deepEqual @masks, a

  describe 'when *empty index*.getIndexesForTerm', ->
    before (done) ->
      index = new Index()
      @masks = index.getIndexesForTerm 'term', (err, @masks) => done err
    it '*no documents* match', ->
      assert.deepEqual @masks, new BitArray()

  describe 'when *document has different fields*.getTerms', ->
    before (done) ->
      index = new Index()
      index.addSync 'yes', parseTerm ['b:1', 'a:123', 'b:123', 'c:1234', 'a:123']
      index.getTerms (err, @terms) => done err
    it 'terms are *sorted by fields, then by terms*', ->
      assert.deepEqual @terms, parseTerm ['a:123', 'b:1', 'b:123', 'c:1234']

  describe 'when *creating a DocumentInverter*', ->
    before (done) ->
      @inverter = new DocumentInverter()
      done()
    '*succeeds*' : (inverter) ->
      assert.instanceOf @inverter, DocumentInverter
