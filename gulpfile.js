const { watch, src, dest, series, parallel } = require('gulp');
const sass = require('gulp-sass')(require('sass'));
const elm = require('gulp-elm');
const rename = require('gulp-rename');
const del = require('del');
const uglify = require('gulp-uglify');
const browserSync = require('browser-sync').create();

const compileSass = (cb) => {
    src('./app/scss/**/*.scss')
        .pipe(sass().on('error', sass.logError))
        .pipe(dest('./dist'))
        .on('end', () => cb());
}

const copyIndex = (cb) => {
    src('./app/index.html')
        .pipe(dest('./dist'))
        .on('end', () => cb());
}

const compileElm = (cb) => {
    src('./app/src/Main.elm')
        .pipe(elm({ optimize: true }))
        .pipe(rename('app.js'))
        .pipe(uglify({
            compress: {
                pure_funcs: [
                    'F2', 'F3', 'F4', 'F5',
                    'F6', 'F7', 'F8', 'F9',
                    'A2', 'A3', 'A4', 'A5',
                    'A6', 'A7', 'A8', 'A9'
                ],
                pure_getters: true,
                keep_fargs: false,
                unsafe_comps: true,
                unsafe: true
            }
        }))
        .pipe(uglify({
            mangle: true
        }))
        .pipe(dest('./dist/'))
        .on('end', () => cb());
};

const deleteDist = (cb) => {
    del('./dist/', { force: true, ignore: '.gitkeep' })
        .then(() => cb())
        .catch(cb);
}

const watchFiles = () => {
    browserSync.init({
        watch: true,
        server: './dist'
    }, () => {
        watch('./app/scss/**/*.scss', compileSass);
        watch('./app/index.html', copyIndex);
        watch('./app/src/**/*.elm', compileElm);
    })
}

exports.watch = series(
    deleteDist,
    parallel(compileSass, copyIndex, compileElm),
    watchFiles
);


exports.build = series(
    deleteDist,
    parallel(compileSass, copyIndex, compileElm)
);