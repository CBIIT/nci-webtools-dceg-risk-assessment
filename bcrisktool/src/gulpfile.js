var stripComments, notifier, parentDir, gulp, gulpConcat, gutil, gulpStylus, streamqueue,  gulpPlumber, nib, jshint, gutil, plumber, gulpJade, gulpFilter;

require('matchdep').filterDev('gulp-*').forEach(function(module){
    global[module.replace(/^gulp-/, '')] = require(module);
});

parentDir = '..';

stripComments = require('gulp-strip-comments');
notifier = require('node-notifier');
gulp = require('gulp');
gulpConcat = require('gulp-concat');
gutil = require('gulp-util');
gulpStylus = require('gulp-stylus');
gulpJade = require('gulp-jade');
streamqueue = require('streamqueue');
gulpPlumber = require('gulp-plumber');
nib = require('nib');
jshint = require('gulp-jshint');
gulpFilter = require('gulp-filter');

plumber = function(){
    return gulpPlumber({
        errorHandler: function(it){
            gutil.beep();
            return gutil.log(gutil.colors.red(it.toString()));
        }
    });
};

gulp.task('default',['build']);

gulp.task('build', ['jade-compile', 'js:copy', 'css'], function(){
    notifier.notify({
        title: 'Compilation Complete',
        message: "The code has been compiled in the project's root directory"
    });
});

gulp.task('dev', ['jade-compile', 'js:copy', 'ls:app', 'css'], function(done){
    gulp.watch(['app/jade/pages/*.jade'], ['jade-compile']);
    return gulp.watch('app/stylus/**/*.styl', ['css']);
});


// task for rendering jade files to HTML
gulp.task('jade-compile', function(){
    // only return the compiled index to root
    return gulp.src(['app/jade/pages/index.jade']).pipe(gulpJade({
        pretty: true,
        basedir: parentDir
    })).pipe(gulp.dest(parentDir));
});

gulp.task('js:copy', function(){
    var s;
    s = streamqueue({
        objectMode: true
    });
    gulp.src('app/scripts/**/*.json')
        .pipe(gulp.dest(parentDir));

    gulp.src(['app/scripts/**/*.js'])
        .pipe(stripComments())
        .pipe(jshint())
        .pipe(jshint.reporter('jshint-stylish'))
        .pipe(gulp.dest(parentDir));
    return s.done();
});

gulp.task('css', function(){
    var styl, s;
    styl = gulp.src(['app/stylus/base-styles.styl', 'app/stylus/mobile-styles.styl']).pipe(gulpFilter(function(it) {
        return !/\/_[^/]+\.styl$/.test(it.path);
    })).pipe(gulpStylus({
        use: [nib()],
        'import': ['nib']
    })).pipe(gulpConcat('styles.css')).pipe(gulp.dest(parentDir));

    return s = streamqueue({
        objectMode: true
    });
});
