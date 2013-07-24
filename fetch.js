var config = require('./config');

var tragic = require('./lib');
var f = new tragic.Fetcher(config.app_id, config.app_key);
var data = f.fetch(config.board);

console.log(data[0]);