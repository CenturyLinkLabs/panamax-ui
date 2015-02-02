describe('$.fn.scrolliePollie', function() {
  var $el,
      subject = null;

  beforeEach(function() {
    jasmine.Ajax.useMock();
    jasmine.Clock.useMock();
    fixture.load('scrollie-pollie.html');

    $el = $('.scrollie');

    subject = new $.PMX.ScrolliePollie($el);
  });

  describe('init', function() {
    it('updates the contents with those from the template', function() {

      var lines = [
        'thing 1',
        'thing 2'
      ];

      expect($('.scrollie').text()).toEqual('');

      subject.init();

      var request = mostRecentAjaxRequest();
      request.response({
        status: 200,
        responseText: JSON.stringify(lines)
      });

      expect($('.scrollie p').first().text()).toEqual('thing 1');
      expect($('.scrollie p').last().text()).toEqual('thing 2');
    });

    it('polls every 1 second', function() {
      initialAjaxRequestCount = ajaxRequests.length;

      subject.init();

      expect(ajaxRequests.length).toEqual(initialAjaxRequestCount + 1);

      jasmine.Clock.tick(1001);

      expect(ajaxRequests.length).toEqual(initialAjaxRequestCount + 2);
    });
  });
});
