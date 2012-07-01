simpleindex
===========

A simple inverted index for javascript.

## Building Documents

### DocumentBuilder

The DocumentBuilder builds a dictionary object of field to value pairs, where the value is a string that is ready to be inverted.

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
  color: (d) -> d.color

# Builds a document object - a simple dictionary of field=value (where value is the string to be inverted).
db = new DocumentBuilder converter
documents = [db.build a for a in {apples}]

```

## Using Filters

Filters transform a term stream to prepare it for indexing.   Filters have a `.filter` method, which accepts and returns an array or array-like object.

### Standard Filters

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

Most filters can be chained together so that the output of one is the input of the next, thus working inside-out.

For example, this combination converts each term to lower, then removes duplicates:

```coffeescript
new DedupFilter(new LowerCaseFilter()).filter(["APPLE","apple", "Orange"])
# yields ["apple", "orange"]
```

