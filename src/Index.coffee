# todo: add ranking ability:
# consider using a float array (indicating tf-idf) instead of a bit array

BitArray = require 'bit-array'

class Index
  constructor: ->
    @currentDocNum = 0
    @documents = []
    @termDocs = []
    @emptyTermDocs = new BitArray()

  count: ->
    @documents.length

  getItemsSync: (indexes) =>
    items = []
    indexes.forEach (value, index) =>
      items.push(@getItemSync index) if value
    return items

  getItemSync: (documentNumber) ->
    if documentNumber > @documents.length
      console.log documentNumber
      return null
    x = @documents[documentNumber]
    unless x?
      console.log "null document at index: " + documentNumber
      return null
    x.document

  add: (document, terms, callback) =>
    process.nextTick =>
      docNum = @addSync(document, terms)
      callback null, @, docNum

  insertTerm: (term, documentNumber) =>
    termObj = _createTerm(term)
    i = 0
    while i < @termDocs.length and _compareTerms(termObj, @termDocs[i].term) > 0
      i++
    if i < @termDocs.length and 0 == _compareTerms(termObj, @termDocs[i].term)
       termDoc = @termDocs[i]
    else
      termDoc =
        term: termObj
        masks: new (BitArray)
      @termDocs.splice i, 0, termDoc
    termDoc.masks.set documentNumber, true


  addSync: (document, terms) ->
    @replaceAtSync @currentDocNum, document, terms
    @resizeAllTerms() if @currentDocNum % 32 == 0
    @currentDocNum++

  replaceAtSync: (index, document, terms) ->
    doc =
      document: document
      terms: terms
      index: index

    @documents[index] = doc
    @insertTerm term, index for term in terms

  resizeAllTerms: =>
    @emptyTermDocs.set @currentDocNum, 0
    tv.masks.set @currentDocNum, tv.masks.get @currentDocNum for tv in @termDocs
    return

  getItem: (documentNumber, callback) =>
    process.nextTick =>
      result = @getItemSync(documentNumber)
      callback null, @, result

  getTermsSync: ->
    terms = []
    i = 0

    while i < @termDocs.length
      terms[i] = @termDocs[i].term
      i++
    terms

  getTerms: (continuation) =>
    process.nextTick =>
      result = @getTermsSync()
      continuation null, result

  getTermDocsForTermSync: (term) ->
    termObj = _createTerm(term)
    i = 0

    while i < @termDocs.length
      t = @termDocs[i].term
      return @termDocs[i]  if termObj.term is t.term and termObj.field is t.field
      i++
    null

  getIndexesForTermSync: (term) =>
    termDocs = @getTermDocsForTermSync(term)
    return @emptyTermDocs  unless termDocs?
    termDocs.masks

  getIndexesForTerm: (term, continuation) =>
    process.nextTick =>
      result = @getIndexesForTermSync(term)
      continuation null, result


module.exports = Index: Index

_createTerm = (term) ->
  if "string" is typeof term
    return (
      field: null
      term: term
    )
  term

_compareTerms = (a, b) ->
  return -1  if a.field < b.field
  if a.field == b.field
    return -1  if a.term < b.term
    return 0  if a.term is b.term
  1
