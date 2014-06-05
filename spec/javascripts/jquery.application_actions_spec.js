describe('$.fn.applicationActions', function () {
  beforeEach(function () {
    fixture.load('applications.html');
    $('section.applications').applicationActions();
    jasmine.Ajax.useMock();
  });

  describe('clicking remove application', function() {
    it('issues the delete', function() {
      $('section.applications .actions .delete').click();
      var request = mostRecentAjaxRequest();
      expect(request.url).toBe('/applications/1');
      expect(request.method).toBe('DELETE');
    });

    it('prevents default behavior', function() {
      var clickEvent = $.Event('click');
      $('section.applications .actions .delete').trigger(clickEvent);
      expect(clickEvent.isDefaultPrevented()).toBeTruthy();
    });

    it('hides the dom element', function() {
      $('section.applications .actions .delete').click();
      var request = mostRecentAjaxRequest();

      request.response({
        status: 200,
        responseText: '{}'
      });

      expect($('div.application').css('opacity')).toBe('0.5');
      // Testing opacity because animations have been turned off
    });
  });

});
