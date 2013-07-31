default: exampleconf

exampleconf:
        cat config.js | tr "[:digit:]" "0" > config.example.js
