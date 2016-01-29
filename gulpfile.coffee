gulp        = require 'gulp'
coffee      = require 'gulp-coffee'

error = (err)->
    console.log err.toString()

    @.emit 'end'

dirDev = "./development/**/*.coffee"
dirBin = "./bin/"

gulp.task 'coffee', (next)->
    gulp.src dirDev
        .pipe coffee({bare: true}).on 'error', error
        .pipe gulp.dest dirBin
        .on 'error', error
        .on 'finish', next

    return

gulp.task 'watch', ->
    gulp.watch dirDev, ['coffee']

gulp.task 'default', ['coffee']