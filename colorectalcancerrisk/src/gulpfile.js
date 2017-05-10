var baseDir = '..';

var gulp = require('gulp');
var load = require('gulp-load-plugins')();
var nib = require('nib');
var notifier = require('node-notifier');
var plumber = function(){
    return load.plumber({
        errorHandler: function(it){
            gutil.beep();
            return gutil.log(gutil.colors.red(it.toString()));
        }
    });
};

gulp.task('default', ['build']);

gulp.task('build', [ 'compile:pug', 'compile:stylus','copy:js' ], function(){
    notifier.notify({
        title: 'Compilation Complete',
        message: "The code has been compiled in the project's root directory"
    });
});

gulp.task('compile:pug', function () {
    return gulp.src(['pug/index.pug'])
    .pipe(
        load.pug({
            pretty: true,
            baseDir: baseDir
        })
    )
    .pipe(gulp.dest( baseDir ));;
});

gulp.task('compile:stylus', function () {
    return gulp.src(['stylus/**/*.styl'])
    .pipe(
        load.stylus({
            use: [ nib() ],
            'import': [ 'nib' ]
        })
    )
    .pipe(load.concat( 'styles.css' ))
    .pipe(gulp.dest( baseDir ));
});

gulp.task('copy:js', function () {
    return gulp.src(['scripts/**/*.js'])
    .pipe(
        gulp.dest( baseDir )
    );
});

gulp.task('checkstandards', function () {
    return gulp.src([
        baseDir + '/*.html', 
        baseDir + '/*.css', 
        baseDir + '/*.js' ])
    .pipe(load.webstandards());
});