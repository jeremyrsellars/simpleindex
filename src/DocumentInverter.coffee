
DedupFilter = require('./DedupFilter.coffee').DedupFilter
LowerCaseFilter = require('./LowerCaseFilter.coffee').LowerCaseFilter
PrefixFilter = require('./PrefixFilter.coffee').PrefixFilter

fieldize = (fieldName, tokens) ->
  (new PrefixFilter(fieldName + ':')).filter tokens

isString = (s) ->
  typeof s == 'string' || s instanceof String

class DocumentInverter
  constructor: (optionalFilter) ->
    @filter = optionalFilter ? new DedupFilter new LowerCaseFilter()

  invertSync: (d) =>
    if isString d
      @invertStringSync d
    else
      @invertDocumentSync d

  invertDocumentSync: (d) =>
    termArrays = []
    termArrays.push fieldize field, @getTerms value for own field, value of d
    terms = []
    for ta in termArrays
      for t in ta
        terms.push t
    terms
  
  getTerms: (stringOrStringArray) =>
    if isString stringOrStringArray
      return @invertStringSync stringOrStringArray
    else if stringOrStringArray instanceof Array
      return stringOrStringArray
    else
      throw new Error 'getTerms expected string or array of terms'

  invertStringSync: (s) =>
    allTerms = @tokenizeSync s
    return @filter.filter allTerms

  tokenizeSync: (s) =>
    pattern = /[a-z]+/ig
    match = s.match pattern
    return match unless match == '' or match == null
    return []

module.exports =
  DocumentInverter: DocumentInverter
