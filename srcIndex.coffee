Index = ->
  @currentDocNum = 0
  @documents = []
  @termDocs = []
BitArray = require("bit-array")
Index::addSync = (document, terms) ->
  doc =
    document: document
    terms: terms
    index: @currentDocNum

  @documents[@currentDocNum] = doc
  @currentDocNum++

Index::count = ->
  @documents.length

Index::getItemSync = (documentNumber) ->
  if documentNumber > @documents.length
    console.log documentNumber
    return null
  x = @documents[documentNumber]
  unless x?
    console.log "null document at index: " + documentNumber
    return null
  x.document

Index::add = (document, terms, callback) ->
  t = this
  process.nextTick ->
    docNum = t.addSync(document, terms)
    callback null, t, docNum

Index::insertTerm = (term, documentNumber) ->
  i = undefined
  termDoc = undefined
  termObj = _createTerm(term)
  i = 0
  while i < @termDocs.length and _compareTerms(termObj, @termDocs[i].term) > 0
    i++
  unless i < @termDocs.length and (0 is _compareTerms(termObj, @termDocs[i].term))
    termDoc =
      term: termObj
      masks: new (BitArray)

    @termDocs.splice i, 0, termDoc
  termDoc.masks.set documentNumber, true

_compareTerms = (a, b) ->
  return -1  if a.field < b.field
  if a.field is b.field
    return -1  if a.term < b.term
    return 0  if a.term is b.term
  1

Index::addSync = (document, terms) ->
  doc =
    document: document
    terms: terms
    index: @currentDocNum

  @documents[@currentDocNum] = doc
  i = 0

  while i < terms.length
    @insertTerm terms[i], @currentDocNum
    i++
  @currentDocNum++

Index::getItem = (documentNumber, callback) ->
  t = this
  process.nextTick ->
    result = t.getItemSync(documentNumber)
    callback null, t, result

Index::getTermsSync = ->
  terms = []
  i = 0

  while i < @termDocs.length
    terms[i] = @termDocs[i].term
    i++
  terms

Index::getTerms = (continuation) ->
  t = this
  process.nextTick ->
    result = t.getTermsSync()
    continuation null, result

Index::getTermDocsForTermSync = (term) ->
  termObj = _createTerm(term)
  i = 0

  while i < @termDocs.length
    t = @termDocs[i].term
    return @termDocs[i]  if termObj.term is t.term and termObj.field is t.field
    i++
  null

_createTerm = (term) ->
  if "string" is typeof term
    return (
      field: null
      term: term
    )
  term

Index::getIndexesForTermSync = (term) ->
  termDocs = @getTermDocsForTermSync(term)
  return new BitArray()  unless termDocs?
  termDocs.masks

Index::getIndexesForTerm = (term, continuation) ->
  t = this
  process.nextTick ->
    result = t.getIndexesForTermSync(term)
    continuation null, result

module.exports = Index: Index