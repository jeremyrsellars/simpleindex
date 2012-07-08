module.exports = {
  Index: require("./lib/Index.js").Index
  ,DedupFilter: require("./lib/DedupFilter.js").DedupFilter
  ,DocumentBuilder: require("./lib/DocumentBuilder.js").DocumentBuilder
  ,DocumentInverter: require("./lib/DocumentInverter.js").DocumentInverter
  ,IndexSearcher: require("./lib/IndexSearcher.js").IndexSearcher
  ,LowerCaseFilter: require("./lib/LowerCaseFilter.js").LowerCaseFilter
  ,PrefixFilter: require("./lib/PrefixFilter.js").PrefixFilter
  ,Query: require("./lib/Query.js").Query
  ,StopWordFilter: require("./lib/StopWordFilter.js").StopWordFilter
}
