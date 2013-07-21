var config = {
  app_id: '38e3c9586d9a74c086ec41d48aa14d96'
  , app_key: '4d2a0525bdb0cf88ac8d6bf5fc22d3365e20cb8f52e6666b932d2c76440ec45c'
};

var tragic = require('./lib/');
var f = new tragic.Fetcher(config);
var data = f.fetch('4f7696a77aaa0177051298fb');

console.log(data[0]);