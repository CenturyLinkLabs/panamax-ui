describe('$.fn.destroyLink', function () {
  var subject, successCalled, failCalled;
  beforeEach(function () {
    fixture.load('destroy-link.html');
    subject = new $.PMX.destroyLink($('ul.destroy'),
      {
        success: function() {
          successCalled = true;
        },
        fail: function() {
          failCalled = true;
        }
      });
    subject.init();
    jasmine.Ajax.useMock();
  });

  describe('clicking remove link', function() {
    it('issues the delete', function() {
      $('ul.destroy li .actions .delete-action').click();
      var request = mostRecentAjaxRequest();

      expect(request.url).toBe('/destroy_location/1');
      expect(request.method).toBe('DELETE');
    });

    it('prevents default behavior', function() {
      var clickEvent = $.Event('click');
      $('ul.destroy li .actions .delete-action').trigger(clickEvent);

      expect(clickEvent.isDefaultPrevented()).toBeTruthy();
    });

    it('hides the dom element', function() {
      $('ul.destroy li .actions .delete-action').click();
      var request = mostRecentAjaxRequest();

      request.response({
        status: 200,
        responseText: '{}'
      });

      expect($('ul.destroy li').css('opacity')).toBe('0.5');
      // Testing opacity because animations have been turned off
    });

    it('calls fail callback when delete was unsuccessful', function(){
      $('ul.destroy li .actions .delete-action').click();
      var request = mostRecentAjaxRequest();

      request.response({
        status: 500,
        responseText: '{}'
      });

      expect(failCalled).toBeTruthy();
    })
  });

});