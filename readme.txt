index = new Index ();
tokens = new [] {'brown', 'red'};
index.addSync ('brown squirrels taste better than red squirrels.', terms);
tokens = new [] {'quick', 'brown', 'lazy'};
index.add ('The quick, brown fox jumped over the lazy dog.', terms, callback);
index.getItem(0, callback) // calls the function with the first item added to list
index.getItemSync(1) // yields the second item added to list
index.getIndexesForTerm('brown', callback) // yields items with the specified term

getIngredients = (recipe) ->
	s = ''
	s +' ' + ingredient for ingredient in recipe.ingredients
	return s

documentConverter =
	'title': (recipe) -> recipe.title
	'ingredients': getIngredients
	'source': (recipe) -> recipe.source



ingredients:(ground beef and peppers)


title:'stuffed green peppers'
ingredients:'ground beef, green peppers, salt, black pepper, tomato sauce'
tags:'fast, low-carb'

title:['stuffed', 'green', 'peppers']
ingredients:['ground beef', 'green peppers', 'salt', 'black pepper', 'tomato sauce']
tags:['fast']

indexSearcher = new (IndexSearcher)(myIndex)

new TermQuery('field', 'term')