class LowerCaseFilter
  constructor: (subFilter) ->
	  this.subFilter = subFilter
	  return

  filter: (terms) ->
    terms = this.subFilter.filter(terms) if this.subFilter?
    return (term.toLowerCase() for term in terms)

module.exports =
  LowerCaseFilter: LowerCaseFilter
