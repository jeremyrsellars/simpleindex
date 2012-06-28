simpleindex
===========

A simple inverted index for javascript.

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
 
### Chaining

Most filters can be chained together so that the output of one is the input of the next, thus working inside-out.

For example, this combination converts each term to lower, then removes duplicates:

```coffeescript
new DedupFilter(new LowerCaseFilter()).filter(["APPLE","apple", "Orange"])
# yields ["apple", "orange"]
```

