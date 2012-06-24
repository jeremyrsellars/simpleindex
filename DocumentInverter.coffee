dedupFilter = require './DedupFilter.coffee'
DedupFilter = dedupFilter.DedupFilter
lowerCaseFilter = require './LowerCaseFilter.coffee'
LowerCaseFilter = lowerCaseFilter.LowerCaseFilter

class DocumentInverter
  constructor: () ->
    return

  invertSync: (s) ->
    allTerms = this.tokenizeSync s
    filter = new DedupFilter (new LowerCaseFilter)
    return filter.filter allTerms

  insertTermSync: (terms, term) ->
    i = 0
    `
      for (; i < terms.length && term > terms[i]; i++)
        ;
    `
    return if i < terms.length && (term == terms[i])
    terms.splice i, 0, term
    return

  tokenizeSync: (s) ->
    pattern = /[a-z]+/ig
    match = s.match pattern
    return [] if match == '' or match == null
    return match;

module.exports =
  DocumentInverter: DocumentInverter
