describe('$.fn.serviceActions', function () {
  beforeEach(function () {
    fixture.load('manage-service.html');
    $('ul.services li').serviceActions();
    jasmine.Ajax.useMock();
    jasmine.Clock.useMock();
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

  });

});