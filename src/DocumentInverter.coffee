dedupFilter = require './DedupFilter.coffee'
DedupFilter = dedupFilter.DedupFilter
lowerCaseFilter = require './LowerCaseFilter.coffee'
LowerCaseFilter = lowerCaseFilter.LowerCaseFilter

class DocumentInverter
  constructor: (filter) ->
    @filter = filter ? new DedupFilter new LowerCaseFilter()

  invertSync: (s) =>
    allTerms = @tokenizeSync s
    return @filter.filter allTerms

  insertTermSync: (terms, term) =>
    i = 0
    `
      for (; i < terms.length && term > terms[i]; i++)
        ;
    `
    return if i < terms.length && (term == terms[i])
    terms.splice i, 0, term
    return

  tokenizeSync: (s) =>
    pattern = /[a-z]+/ig
    match = s.match pattern
    return match unless match == '' or match == null
    return []

module.exports =
  DocumentInverter: DocumentInverter
