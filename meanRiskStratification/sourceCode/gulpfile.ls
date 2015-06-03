require 'matchdep'
  .filterDev 'gulp-*'
  .forEach (module) !->
    global[ module.replace /^gulp-/, '' ] = require module

notifier = require \node-notifier
parent-dir = \..

require! <[ gulp gulp-util gulp-stylus gulp-livereload gulp-livescript streamqueue gulp-if gulp-plumber nib ]>
gutil = gulp-util

dev = gutil.env._.0 is \dev
plumber = ->
  gulp-plumber error-handler: ->
    gutil.beep!
    gutil.log gutil.colors.red it.toString!

#livereload-server = require('tiny-lr')!
#livereload = -> gulp-livereload livereload-server

var http-server
production = true if gutil.env.env is \production

#gulp.task 'webdriver_update' webdriver_update

#gulp.task 'protractor' <[webdriver_update httpServer]> ->
#  gulp.src ["./test/e2e/app/*.ls"]
#    .pipe protractor configFile: "./test/protractor.conf.ls"
#    .on 'error' ->
#      throw it

#gulp.task 'test:e2e' <[protractor]> ->
#  httpServer.close!

#gulp.task 'protractor:sauce' <[webdriver_update build httpServer]> ->
#  args =
#    '--selenium-address'
#    ''
#    '--sauce-user'
#    process.env.SAUCE_USERNAME
#    '--sauce-key'
#    process.env.SAUCE_ACCESS_KEY
#    '--capabilities.build'
#    process.env.TRAVIS_BUILD_NUMBER
#  if process.env.TRAVIS_JOB_NUMBER
#    #args['capabilities.tunnel-identifier'] = that
#    args.push '--capabilities.tunnel-identifier'
#    args.push that
#
#  gulp.src ["./test/e2e/app/*.ls"]
#    .pipe protractor do
#      configFile: "./test/protractor.conf.ls"
#      args: args
#    .on 'error' ->
#      throw it

#gulp.task 'test:sauce' <[protractor:sauce]> ->
#  httpServer.close!

# to compile, run command 'npm run build'
gulp.task 'build' <[ template bower js:mergeScripts js:app css ]> !->

  notifier.notify(
    title: 'Compilation Complete',
    message: "The code has been compiled in the project's root directory")

# gulp.task 'test:unit' <[build]> ->
#  gulp.start 'test:karma' ->
#    process.exit!
#
#gulp.task 'test:karma' (done) ->
#  require 'karma' .server.start {
#    config-file: __dirname + '/test/karma.conf.ls',
#    single-run: true
#  }, done

gulp.task 'dev' <[template js:mergeScripts js:app css]> (done) ->
#  gulp.start 'httpServer'
  gulp.watch ['app/**/*.jade'] <[template]>
  gulp.watch ['app/**/*.ls'] <[js:app]>
  gulp.watch 'app/**/*.styl' <[css]>
#  require 'karma' .server.start {
#    config-file: __dirname + '/test/karma.conf.ls',
#  }, ->
#    done!
#    process.exit!

require! <[ gulp-jade]>
gulp.task 'template' <[index]> ->
  gulp.src ['app/partials/**/*.jade']
    .pipe gulp-if dev, plumber!
    .pipe gulp-jade!
    .pipe gulp-if dev, livereload!

gulp.task 'index' ->
  pretty = 'yes' if gutil.env.env isnt \production

  gulp.src ['app/*.jade']
    .pipe gulp-jade do
      pretty: pretty
    .pipe gulp.dest parentDir
    .pipe gulp-if dev, livereload!

require! <[gulp-bower main-bower-files gulp-filter gulp-csso]>
require! <[gulp-concat gulp-json-editor gulp-commonjs gulp-insert]>

gulp.task 'bower' ->
  gulp-bower!

gulp.task 'js:app' ->
  #copy common to root
  gulp.src 'app/assets/common/**/*.*'
    .pipe gulp.dest "#{parentDir}/common"

  #copy json files
  gulp.src 'app/assets/*.json'
    .pipe gulp.dest parentDir

  env = gulp.src 'app/**/*.jsenv'
    .pipe gulp-json-editor (json) ->
      for key of json when process.env[key]?
        json[key] = that
      json
#    .pipe gulp-insert.prepend 'module.exports = '
#    .pipe gulp-commonjs!

  app = gulp.src 'app/**/*.ls'
    .pipe gulp-if dev, plumber!
    .pipe gulp-livescript({+bare}).on 'error', gutil.log

gulp.task 'js:mergeScripts' <[bower]> ->
#  bower = gulp.src main-bower-files!
#    .pipe gulp-filter -> it.path is /\.js$/

  s = streamqueue { +objectMode }
    .done gulp.src 'app/assets/js/*.js'
    .pipe gulp-concat 'scripts.js'
    .pipe gulp.dest parentDir
    .pipe gulp-if dev, livereload!

gulp.task 'css' <[bower]> ->
  bower = gulp.src main-bower-files!
    .pipe gulp-filter -> it.path is /\.css$/

  # searches the styles directory for .styl files and combines all styles into one file
  styl = gulp.src './app/styles/**/*.styl'
    .pipe gulp-filter -> it.path isnt /\/_[^/]+\.styl$/
    .pipe gulp-stylus use: [nib!]

  s = streamqueue { +objectMode }
    .done bower, styl, gulp.src 'app/styles/**/*.css'
    .pipe gulp-concat 'styles.css'
    .pipe gulp-if production, gulp-csso!
    .pipe gulp.dest parentDir
    .pipe gulp-if dev, livereload!