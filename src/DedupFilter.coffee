# yields unique terms

class DedupFilter
  constructor: (@subFilter) ->

  filter: (allTerms) ->
    allTerms = this.subFilter.filter(allTerms) if this.subFilter?
    @terms = []
    @insertTermSync terms, term for term in allTerms
    return terms

  insertTermSync: (terms, term) ->
    i = 0
    `
      for (; i < terms.length && term > terms[i]; i++)
        ;
    `
    return if i < terms.length && (term == terms[i])
    terms.splice i, 0, term
    return

module.exports =
  DedupFilter: DedupFilter
