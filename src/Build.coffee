fs = require 'fs'

shouldBuild = (f) ->
    ((f.indexOf '.coffee') > 0) and 
        (f.indexOf '.Test.coffee') is -1 and 
        (f isnt 'Build.coffee')

getBuildCmd = (f) ->
    'coffee -c -l -o ../lib/ ' + f

filesToBuild = (f for f in fs.readdirSync './' when shouldBuild f)

console.log getBuildCmd f for f in filesToBuild
