simpleindex
===========

A simple inverted index for javascript.

## Using Filters

Filters transform a term stream to prepare it for indexing.  Most filters can be chained together so that the output of one is the input of the next.

For example, this combination converts each term to lower, then removes duplicates:

    new DedupFilter(new LowerCaseFilter()).filter(["APPLE","apple", "Orange"])  # yields ["apple", "orange"]

### Standard Filters

These filters ought to get you started.  Filters are expted to have a `.filter` method, which accepts and returns an array or array-like object.

**DedupFilter** - Removes duplicate terms from the term stream

    new DedupFilter()
    new DedupFilter(subfilter)
 
**LowerCaseFilter** - Yields terms converted to lowercase

    new LowercaseFilter()
    new LowercaseFilter(subfilter)
 
**StopWordFilter** - Yields terms that are not in the configurable list of stopwords

    new StopWordFilter(stopwordsArray)
    new StopWordFilter(stopwordsArray, subfilter)
 
