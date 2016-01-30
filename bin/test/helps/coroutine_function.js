var ack;

ack = require('../../../ack');

ack(function(name) {
  switch (name) {
    case "Rincewind":
      return "wizzard";
    case "Twoflower":
      return "tourist";
    case "The Luggage":
      return "chest";
    default:
      return "oops";
  }
});
