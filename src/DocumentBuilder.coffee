class DocumentBuilder
  constructor: (converter) ->
    @converter = converter
    return

  build: (o) ->
    doc = {}
    doc[field] = fieldGetter(o) for own field, fieldGetter of @converter
    doc

module.exports =
  DocumentBuilder: DocumentBuilder
