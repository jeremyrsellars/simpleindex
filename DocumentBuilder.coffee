class DocumentBuilder
  constructor: (converter) ->
    @converter = converter
    return

  build: (o) ->
    doc = new Object
    doc[field] = fieldGetter(o) for own field, fieldGetter of @converter
    return doc

module.exports =
  DocumentBuilder: DocumentBuilder
