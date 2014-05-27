describe('$.fn.serviceActions', function () {
  var serviceEventCalled = true;

  beforeEach(function () {
    fixture.load('manage-service.html');
    $('ul.services li').serviceActions();
    $('ul.services').on('service-event', function() {
      serviceEventCalled = true;
    });
    jasmine.Ajax.useMock();
  });

  describe('clicking remove service', function() {
    it('issues the delete', function() {
      $('ul.services li .actions .delete-action').click();
      var request = mostRecentAjaxRequest();
      expect(request.url).toBe('/applications/1/services/1');
      expect(request.method).toBe('DELETE');
    });

    it('prevents default behavior', function() {
      var clickEvent = $.Event('click');
      $('ul.services li .actions .delete-action').trigger(clickEvent);
      expect(clickEvent.isDefaultPrevented()).toBeTruthy();
    });

    it('hides the dom element', function() {
      $('ul.services li .actions .delete-action').click();
      var request = mostRecentAjaxRequest();

      request.response({
        status: 200,
        responseText: '{}'
      });

      expect($('ul.services li').css('opacity')).toBe('0.5');
      // Testing opacity because animations have been turned off
    });

    it ('triggers service-event ', function() {
      var request = mostRecentAjaxRequest();

      request.response({
        status: 200,
        responseText: '{}'
      });
      $('ul.services li .actions .delete-action').click();

      expect(serviceEventCalled).toBeTruthy();
    });
  });

});