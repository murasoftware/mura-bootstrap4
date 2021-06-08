// var path = require('path');
var gulp = require('gulp');
var sass = require('gulp-sass');
var autoprefixer = require('gulp-autoprefixer');
var cssnano = require('gulp-cssnano');

gulp.task('default', async function() {
	gulp.series('bootstrap');
	gulp.series('scss-theme');
});

gulp.task('theme', async function() {
	gulp.series('scss-theme');
});

gulp.task('watch', async function() {
	gulp.watch('scss/**/*.scss', gulp.series('scss-theme'));
});

gulp.task('scss-theme', async function(done) {
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
	
gulp.task('bootstrap', async function(done) {
		gulp.src('scss/bootstrap/*.scss')
		.pipe(sass().on('error', sass.logError))
		.pipe(autoprefixer({
			browsers: ['last 2 versions'],
			cascade: false
		}))
		.pipe(gulp.dest('css/'));
		done();
});

function swallowError (error) {
	console.log(error.toString());
	this.emit('end');
}
