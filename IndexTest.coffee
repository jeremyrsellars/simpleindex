vows = require 'vows'
assert = require 'assert'

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

vows.describe('Simple Index: Index').addBatch(
  'An empty index': 
    'topic': new Index
    'when first initialized':
      'is empty': (index) ->
        assert.equal index.count(), 0

  'An empty index 2': 
    'topic': new Index
    'when first document is added *synchronously*':
      'topic': (index) ->
        terms = parseTerm ['brown', 'red']
        idx = index.addSync brownSquirrelsTaste, terms
        return index : index, result : idx
        
      'returns 0': (topic) ->
        assert.equal topic.result, 0
      
      'getItem *synchronously* yields the item': (topic) ->
        assert.equal (topic.index.getItemSync (topic.result)), brownSquirrelsTaste

  'An index with 1 document': 
    'topic': () ->
      index = new Index
      idx = index.addSync brownSquirrelsTaste, ['brown', 'red']
      return index : index, result : idx

    'When getItem *asynchronously*':
      'topic': (topic) -> 
        topic.index.getItem topic.result, this.callback
      'Calls back with Item': (err, index, result) ->
        assert.isNull err
        assert.instanceOf index, Index
        assert.equal result, brownSquirrelsTaste

    'when second document is added *asynchronously*':
      'topic': (topic, t2, t3) ->
        index = topic.index
        topic.index.add quickBrownFox, ['quick', 'brown', 'lazy'], this.callback
        
      'documentNumber is 1': (err, index, docNum) ->
        assert.isNull err
        assert.instanceOf index, Index
        assert.equal docNum, 1
      
      'count is 2': (err, index, docNum) ->
        assert.isNull err
        assert.instanceOf index, Index
        assert.equal index.count(), 2
      
      '*getItem* calls back with the item': (err, index, docNum) ->
        assert.isNull err
        assert.instanceOf index, Index
        assert.equal (index.getItemSync (docNum)), quickBrownFox
      
      'When *getItem*':
        'topic': (index, docNum) -> 
          index.getItem docNum, this.callback
        'Item is the result': (err, index, result) ->
          assert.equal result, quickBrownFox

  'when *no documents*.getTermsSync': 
    'topic': (new Index).getTermsSync()
    'result is array' : (terms) ->
      assert.isArray terms
    'there are no terms' : (terms) ->
      assert.deepEqual terms, []

  'when *no documents*.getTermsSync': 
    'topic': (new Index).getTermsSync()
    'result is array' : (terms) ->
      assert.isArray terms
    'there are no terms' : (terms) ->
      assert.deepEqual terms, []

  'when *one termless document*.getTermsSync': 
    'topic': () -> 
      index = new Index()
      index.addSync '', []
      return index.getTermsSync()
    'there are no terms' : (terms) ->
      assert.deepEqual terms, []

  'when *one one-term document*.getTermsSync': 
    'topic': () -> 
      index = new Index()
      index.addSync 'oneTerm', ['oneTerm']
      return index.getTermsSync()
    'there is *one term*' : (terms) ->
      toneTerm = 
        field: null
        term: 'oneTerm'
      assert.deepEqual terms, [toneTerm]

  'when *one two-term document*.getTermsSync': 
    'topic': () -> 
      index = new Index()
      index.addSync 'two terms', ['two', 'terms']
      return index.getTermsSync()
    'terms are sorted and there are *two terms*' : (terms) ->
      tterms = 
        field: null
        term: 'terms'
      ttwo = 
        field: null
        term: 'two'
      assert.deepEqual terms, [tterms, ttwo]

  'when *one three-term document*.getTermsSync': 
    'topic': () -> 
      index = new Index()
      index.addSync 'only two terms', ['only', 'two', 'terms']
      return index.getTermsSync()
    'terms are sorted and there are *two terms*' : (terms) ->
      tonly = 
        field: null
        term: 'only'
      tterms = 
        field: null
        term: 'terms'
      ttwo = 
        field: null
        term: 'two'
      assert.deepEqual terms, [tonly, tterms, ttwo]

  'when *two documents contain same term*.getTermsSync': 
    'topic': () -> 
      index = new Index()
      index.addSync 'two terms', ['two', 'terms']
      index.addSync 'two terms', ['two', 'terms']
      return index.getTermsSync()
    'terms are sorted and there are *two terms*' : (terms) ->
      tterms = 
        field: null
        term: 'terms'
      ttwo = 
        field: null
        term: 'two'
      assert.deepEqual terms, [tterms, ttwo]

  'when *one one-term document*.getTerms': 
    'topic': () -> 
      index = new Index()
      index.addSync 'oneTerm', ['oneTerm']
      index.getTerms this.callback
    'there is *oneterm*' : (err, terms) ->
      toneTerm = 
        field: null
        term: 'oneTerm'
      assert.deepEqual terms, [toneTerm]

  'when *empty index*.getIndexesForTermSync': 
    'topic': () -> 
      index = new Index()
      index.getIndexesForTermSync 'term'
    'the mask is *[0]*' : (masks) ->
      assert.deepEqual masks, new BitArray()

  'when *yes index*.getIndexesForTermSync (no)': 
    'topic': () -> 
      index = new Index()
      index.addSync 'yes', ['yes']
      index.getIndexesForTermSync 'no'
    'there are *no matches*' : (masks) ->
      assert.deepEqual masks, new BitArray(0)

  'when *yes index*.getIndexesForTermSync (yes)': 
    'topic': () -> 
      index = new Index()
      index.addSync 'yes', ['yes']
      index.getIndexesForTermSync 'yes'
    'the *first document matches*' : (masks) ->
      a = new BitArray();
      a.set 0, true
      assert.deepEqual masks, a

  'when *empty index*.getIndexesForTermSync': 
    'topic': () -> 
      index = new Index()
      index.getIndexesForTermSync 'term'
    'there are *no matches*' : (masks) ->
      assert.deepEqual masks, new BitArray()

  'when *yes no index*.getIndexesForTermSync (yes)': 
    'topic': () -> 
      index = new Index()
      index.addSync 'yes', ['yes']
      index.addSync 'no', ['no']
      index.getIndexesForTermSync 'yes'
    'the *first document matches*' : (masks) ->
      a = new BitArray();
      a.set 0, true
      assert.deepEqual masks, a

  'when *yes no yes index*.getIndexesForTermSync (yes)': 
    'topic': () -> 
      index = new Index()
      index.addSync 'yes', ['yes']
      index.addSync 'no', ['no']
      index.addSync 'yes', ['yes']
      index.getIndexesForTermSync 'yes'
    'the *first and third document matches*' : (masks) ->
      a = new BitArray();
      a.set 0, true
      a.set 2, true
      assert.deepEqual masks, a

  'when *empty index*.getIndexesForTerm': 
    'topic': () -> 
      index = new Index()
      index.getIndexesForTerm 'term', this.callback
    '*no documents* match' : (err, masks) ->
      assert.deepEqual masks, new BitArray()

  'when *document has different fields*.getTerms': 
    'topic': () -> 
      index = new Index()
      index.addSync 'yes', parseTerm ['b:1', 'a:123', 'b:123', 'c:1234', 'a:123']
      index.getTerms this.callback
    'terms are *sorted by fields, then by terms*' : (err, terms) ->
      assert.deepEqual terms, parseTerm ['a:123', 'b:1', 'b:123', 'c:1234']

  'when *creating a DocumentInverter*': 
    'topic': () -> 
      return new DocumentInverter()
    '*succeeds*' : (inverter) ->
      assert.instanceOf inverter, DocumentInverter

).export(module)
