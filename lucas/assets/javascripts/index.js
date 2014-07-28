$(document).ready(function() {

  //Navigation

  var $mobileButton = $('#nav-toggle')

  $mobileButton.sidr({
    name: 'main-nav',
    source: '#navigation',
    side: 'right'
  });

  $(window).touchwipe({
    wipeRight: function() {
      $.sidr('close', 'main-nav');
    },
    wipeLeft: function() {
      $.sidr('open', 'main-nav');
    },
    preventDefaultEvents: false
  });

  //How It Works

  var $header = $('#how-it-works h3');
  $header.click(function (e) {

    var sectionName = e.target.id;

    $('#how-it-works li').removeClass('active');
    $('#how-it-works').attr("class", sectionName).find('p').slideUp();
    $(this).next().slideDown();
    $(this).parent().addClass('active');
  });

});