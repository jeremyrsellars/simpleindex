class module.exports.Query
  constructor: (@matchProvider) ->
  	throw new Error "Argument may not be null: " + matchProvider unless @matchProvider?

  search: (index) ->
    @matchProvider index
