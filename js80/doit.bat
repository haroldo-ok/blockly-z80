call browserify -r ./fake-fs:fs app.js -o js80-browserified.js
type js80-browserified.js | uglifyjs > js80-browserified.min.js
