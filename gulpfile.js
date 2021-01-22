// var path = require('path');
var gulp = require('gulp');
var sass = require('gulp-sass');
var autoprefixer = require('gulp-autoprefixer');
var cssnano = require('gulp-cssnano');

gulp.task('default', function() {
	gulp.start('bootstrap');
	gulp.start('scss-theme');
});

gulp.task('theme', function() {
	gulp.start('scss-theme');
});

gulp.task('watch', function() {
	gulp.watch('scss/**/*.scss', ['scss-theme']);
});

gulp.task('scss-theme', function(done) {
	gulp.src('scss/site/**/*.scss')
		.pipe(sass().on('error', sass.logError))
		.pipe(autoprefixer({
			browsers: ['last 2 versions'],
			cascade: false
		}))
		.pipe(cssnano())
		.pipe(gulp.dest('css/'));
		done();
});

gulp.task('bootstrap', function() {
	gulp.src('scss/bootstrap/*.scss')
		.pipe(sass().on('error', sass.logError))
		.pipe(autoprefixer({
			browsers: ['last 2 versions'],
			cascade: false
		}))
		.pipe(gulp.dest('css/'));
});

function swallowError (error) {
	console.log(error.toString());
	this.emit('end');
}
