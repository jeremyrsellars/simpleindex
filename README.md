simpleindex
===========

A simple inverted index for javascript.  An Index is used to store and retrieve 
objects by one or more of the terms in the object.

## Indexing arbitrarilly formatted objects in 3 steps

Use these steps to index an object, an xml document, a web page, or whatever 
else you can put in an array.

1. [Build a document](#building-documents) with [DocumentBuilder](#documentbuilder)
2. [Invert the document](#documentinverter-example) - Build a term vector
   with [DocumentInverter](#documentinverter)
3. [Index the object](#indexing-an-object) - Add the object with its term vector
   to the [Index](#index).

## Building Documents

For our purposes, a document is an object where the key is the field name 
and the value is a string ready for tokenization and filtering, 
or a pre-tokenized term vector, like this:

```coffeescript
document = {name:"Red delicious", color:["Red"]}
```

Documents can be built with the DocumentBuilder and inverted (turned into 
a token vector) with DocumentInverter.

### DocumentBuilder

The DocumentBuilder builds a dictionary object of field to value pairs, 
where the value is a string that is ready to be inverted.

#### DocumentBuilder Example
```coffeescript
# Objects to put in index
apples = [
    {
        variety: "Golden Delicious"
        identified: 1914
        color: "Yellow"
        description: "The Golden Delicious is a cultivar of apple with a yellow color..."
    },
    {
        variety: "Red Delicious"
        identified: 1880
        color: "Red"
        description: "The Red Delicious is a clone of apple cultigen..."
    }
]

# This converter defines the fields and where to get them from the object.
converter =
  name:  (d) -> d.variety
  body:  (d) -> d.description
  year:  (d) -> d.identified.toString()
  color: (d) -> [d.color] # a vector is treated as pre-tokenized terms

# Builds a document object - a simple dictionary of field=value
# (where value is the string to be inverted).
db = new DocumentBuilder converter
documents = [db.build a for a in {apples}]
```

### DocumentInverter

The DocumentInverter takes a document object or string and converts it
to a term vector.  By default, DocumentInverter will use [Filters](#using-filters)
to normalize terms into lower case and remove duplicate terms.

#### DocumentInverter Example

```coffeescript
docInv = new DocumentInverter new DedupFilter new LowerCaseFilter()
apple = variety: "Red Delicious", identified: 1880, color: "Red"
terms = docInv.invertSync db.build apple
# terms = ["name:red", "name:delicious", "year:1880", "color:Red"]
```

## Indexing an Object

Now that your object has been described with a term vector, it is ready
to be added to the index.

### Index

An Index is used to store and retrieve objects by one or more of the terms
representing the object.

### Indexing Example

```coffeescript
index = new Index()
apple = variety: "Red Delicious", identified: 1880, color: "Red"
index.addSync apple, ["name:red", "name:delicious", "year:1880", "color:Red"]
```

## Advanced

### Using Filters

Filters transform a term stream to prepare it for indexing.   Filters have
a `.filter` method, which accepts and returns an array or array-like object.

#### Standard Filters

These filters ought to get you started.

**DedupFilter** - Removes duplicate terms from the term stream

```coffeescript
new DedupFilter()
new DedupFilter(subfilter)
```
 
**LowerCaseFilter** - Yields terms converted to lowercase

```coffeescript
new LowercaseFilter()
new LowercaseFilter(subfilter)
```
 
**StopWordFilter** - Yields terms that are not in the configurable list of stopwords

```coffeescript
new StopWordFilter(stopwordsArray)
new StopWordFilter(stopwordsArray, subfilter)
```
 
**PrefixFilter** - Yields terms prepended with a string

```coffeescript
new PrefixFilter(prefix)
new PrefixFilter(prefix, subfilter)

# Example:
new PrefixFilter("tag:").filter(['salad', 'breakfast'])
# yields ['tag:salad', 'tag:breakfast']
```
 
#### Filter Chaining

Most filters can be chained together so that the output of one is the input
of the next, thus working inside-out.

For example, this combination converts each term to lower, then removes duplicates:

```coffeescript
new DedupFilter(new LowerCaseFilter()).filter(["APPLE","apple", "Orange"])
# yields ["apple", "orange"]
```

## Searching

### Searching an index with an IndexSearcher and a Query

An IndexSearcher lets you query an index.  A query finds all the matches in an index 
and returns a BitArray representing the matching doctors.

```coffeescript
lunchButNotSaladQuery = new Query (index) ->
  hits = new BitArray()
  hits.or index.getIndexesForTermSync 'tag:salad'
  hits.not()
  hits.and index.getIndexesForTermSync 'tag:lunch'
  return hits

searcher = new IndexSearcher index
hits = searcher.search lunchButNotSaladQuery
documents = index.getItemsSync hits
```
