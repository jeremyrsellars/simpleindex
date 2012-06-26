
DedupFilter = (subFilter) ->
  this.subFilter = subFilter
  return

DedupFilter.prototype.filter = (allTerms) ->
  allTerms = this.subFilter.filter(allTerms) if this.subFilter?
  terms = []
  this.insertTermSync terms, term for term in allTerms
  return terms

DedupFilter.prototype.insertTermSync = (terms, term) ->
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
