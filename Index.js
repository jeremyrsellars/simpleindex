// todo: add ranking ability:
// consider using a float array (indicating tf-idf) instead of a bit array

var BitArray = require ('bit-array');

function Index() {
  this.currentDocNum = 0;
  this.documents = [];
  this.termDocs = [];
}

Index.prototype.addSync =  function (document, terms) {
  var doc = {document : document, terms : terms, index : this.currentDocNum};
  this.documents[this.currentDocNum] = doc;
  return this.currentDocNum++;
};

Index.prototype.count = function () {
  return this.documents.length;
};

Index.prototype.getItemSync = function(documentNumber) {
  if (documentNumber > this.documents.length)
  {
    console.log (documentNumber);
    return null;
  }
  var x = this.documents[documentNumber];
  if (x == null)
  {
    console.log ("null document at index: " + documentNumber);
    return null;
  }
  return x.document;
};

Index.prototype.add = function (document, terms, callback) {
  var t = this;
  process.nextTick(function () {
    var docNum = t.addSync(document, terms);
    callback (null, t, docNum);
  });
};

Index.prototype.insertTerm = function (term, documentNumber) {
  var i;
  var termDoc;
  var termObj = _createTerm(term);
  for (i = 0; 
    i < this.termDocs.length && _compareTerms(termObj, this.termDocs[i].term) > 0;
    i++)
     ;
  if (i < this.termDocs.length && (0 == _compareTerms(termObj, this.termDocs[i].term)))
    termDoc = this.termDocs[i];
  else
  {
    termDoc = {term:termObj, masks:new (BitArray)}
    this.termDocs.splice (i, 0, termDoc);
  }
  termDoc.masks.set(documentNumber, true);
};

_compareTerms = function (a, b) {
  if (a.field < b.field)
    return -1;
  if (a.field == b.field)
  {
    if (a.term < b.term)
      return -1;
    if (a.term == b.term)
      return 0;
  }
  return 1;
};

Index.prototype.addSync = function (document, terms) {
  var doc = {document : document, terms : terms, index : this.currentDocNum};
  this.documents[this.currentDocNum] = doc;
  for (var i = 0; i < terms.length; i++)
    this.insertTerm (terms[i], this.currentDocNum);
  return this.currentDocNum++;
};

Index.prototype.getItem = function(documentNumber, callback) {
  var t = this;
  process.nextTick(function () {
    var result = t.getItemSync (documentNumber);
    callback (null, t, result);
  });
};

Index.prototype.getTermsSync = function() {
  var terms = [];
  for (var i = 0; i < this.termDocs.length; i++)
    terms[i] = this.termDocs[i].term
  return terms;
};

Index.prototype.getTerms = function(continuation) {
  var t = this;
  process.nextTick(function () {
    var result = t.getTermsSync ();
    continuation (null, result);
  });
};

Index.prototype.getTermDocsForTermSync = function(term) {
  var termObj = _createTerm(term)
  for (var i = 0; i < this.termDocs.length; i++)
  {
    var t = this.termDocs[i].term;
    if (termObj.term == t.term && termObj.field == t.field)
        return this.termDocs[i];
  }
  return null;
};

_createTerm = function (term) {
  if ('string' == typeof term)
    return {field: null, term:term};
  return term;
};

Index.prototype.getIndexesForTermSync = function(term) {
  var termDocs = this.getTermDocsForTermSync(term);
  if (termDocs == null)
    return new BitArray();
  return termDocs.masks;
};

Index.prototype.getIndexesForTerm = function(term, continuation) {
  var t = this;
  process.nextTick(function () {
    var result = t.getIndexesForTermSync (term);
    continuation (null, result);
  });
};

module.exports = {
  Index: Index 
}
