class PrefixFilter
  constructor: (prefix, @subFilter) ->
      @prefix = prefix ? ''

  filter: (terms) =>
    terms = this.subFilter.filter(terms) if this.subFilter?
    return (@prefix + term for term in terms)

module.exports =
  PrefixFilter: PrefixFilter
