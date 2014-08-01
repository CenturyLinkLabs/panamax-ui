Handlebars.registerHelper('optionsForSelect', function(options) {
  var optionString = "";

  for(var i=0, j=options.length; i<j; i++) {
    optionString += '<option value="' + options[i] + '">' + options[i] + '</option>';
  }

  return optionString;
});
