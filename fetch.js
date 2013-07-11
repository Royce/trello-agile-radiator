var config = {
  app_id: '38e3c9586d9a74c086ec41d48aa14d96'
  , app_key: '4d2a0525bdb0cf88ac8d6bf5fc22d3365e20cb8f52e6666b932d2c76440ec45c'
}
var Fetcher = require('./lib/fetch_from_trello');
var f = new Fetcher(config);
var data = f.fetch('4f7696a77aaa0177051298fb');

//
var Trello = require("node-trello");
var asyncblock  = require("asyncblock");
var t = new Trello(
  '38e3c9586d9a74c086ec41d48aa14d96'
  , '4d2a0525bdb0cf88ac8d6bf5fc22d3365e20cb8f52e6666b932d2c76440ec45c'
);

var iteration_board = '4f7696a77aaa0177051298fb';
var backlog_board = '';
var done_board = '';

var getListLookup = function(api, board, f) {
  api.get('/1/board/'+board+'/lists', { fields: 'name' }, function(err, data) {
    if (err) f(err, data);

    var lookup = {};
    for (var i = data.length - 1; i >= 0; i--) {
    	lookup[data[i].id] = data[i].name;
    }
    f(err, lookup);
  });
};

var getCards = function(api, board, f) {
  var details = { fields: 'name,idList,labels', checklists: 'all' };
  api.get('/1/board/'+board+'/cards', details, f);
};

var translateListIds = function(cards, listLookup) {
  for (var i = cards.length - 1; i >= 0; i--) {
    cards[i].list = listLookup[cards[i].idList];
    delete cards[i].idList;
  };
};

var flattenLabels = function(cards) {
  var labels;
  for (var i = cards.length - 1; i >= 0; i--) {
    for (var j = cards[i].labels.length - 1; j >= 0; j--) {
      labels = [];
      if (cards[i].labels[j].name.length) {
        labels.push(cards[i].labels[j].name);
      }
      cards[i].labels = labels;
    }
  }
};

var disectName = function(cards) {
  var parts;
  for (var i = cards.length - 1; i >= 0; i--) {
    parts = cards[i].name.match(/^(?:\((.+?)\)\s+)?(?:(.+)\:\s)?(.*)$/);
    if (parts && parts[1]) {
      cards[i].size = parts[1];
    }
    if (parts && parts[2]) {
      cards[i].prefix = parts[2];
    }
    if (parts && parts[3]) {
      cards[i].name = parts[3];
    }
  }
};

var disectChecklists = function(cards) {
  for (var i = cards.length - 1; i >= 0; i--) {
    var remainingTasks = [];
    for (var j = cards[i].checklists.length - 1; j >= 0; j--) {
      for (var k = cards[i].checklists[j].checkItems.length - 1; k >= 0; k--) {
        var item = cards[i].checklists[j].checkItems[k];
        if (item.state === 'incomplete') {
          var parts = item.name.match(/^(?:\((.+?)\)\s+)?(?:(.+)\:\s)?(.*)$/);
          if (parts && parts[1] && parts[3]) {
            remainingTasks.push({
              size:parts[1]
              , name:parts[3]
              , list: cards[i].checklists[j].name
            });
          }
        }
      }
    }
    cards[i].remainingTasks = remainingTasks;
    delete cards[i].checklists;
  }
};


asyncblock(function(flow) {
  var listLookup = flow.future();
  getListLookup(t, iteration_board, listLookup);

  var cardsFuture = flow.future();
  getCards(t, iteration_board, cardsFuture);

  var cards = cardsFuture.result;
  flattenLabels(cards);
  disectName(cards);
  disectChecklists(cards);
  translateListIds(cards, listLookup.result);

  console.log(cards[0]);
});
