for %%f in (*.Test.coffee) DO mocha %%f --require coffee-script -R spec
