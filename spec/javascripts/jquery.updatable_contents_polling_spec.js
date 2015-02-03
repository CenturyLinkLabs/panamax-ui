describe('$.fn.updatableContentsPolling', function() {
  var $el,
      subject = null;

  beforeEach(function() {
    jasmine.Ajax.useMock();
    jasmine.Clock.useMock();
    fixture.load('updatable-contents.html');

    $el = $('.updatable-item');

    subject = new $.PMX.UpdatableContentsPolling($el, {
      urlDataAttribute: 'url',
      template: Handlebars.compile($('#updatable_item_template').html())
    });
  });

  describe('init', function() {
    it('updates the contents with those from the template', function() {

      var successMessage = 'successfully refreshed';

      expect($('.updatable-item p').text()).not.toEqual(successMessage);

      subject.init();

      var request = mostRecentAjaxRequest();
      request.response({
        status: 200,
        responseText: JSON.stringify({message: successMessage })
      });

      expect($('.updatable-item p').text()).toEqual(successMessage);
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
