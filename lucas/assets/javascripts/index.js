$(document).ready(function() {

  //How It Works

  var $header = $('#how-it-works h3');
  $header.click(function (e) {

    var sectionName = e.target.id;

    $('#how-it-works li').removeClass('active');
    $(this).parent().toggleClass('active');
    $('#how-it-works').attr("class", sectionName);

  });
});