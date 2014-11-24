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

    it('stops propagation', function() {
      var clickEvent = $.Event('click');
      $('ul.destroy li .actions .delete-action').trigger(clickEvent);

      expect(clickEvent.isPropagationStopped()).toBeTruthy();
    });

    describe('when disableWith option provided', function() {
      beforeEach(function() {
        subject = new $.PMX.destroyLink($('ul.destroy'),
          {
            disableWith: 'Deleting...'
          });
        subject.init();
      });
      it('updates the target html', function() {
        $('ul.destroy li .actions .delete-action').click();
        expect($('ul.destroy li .actions .delete-action').html()).toEqual('Deleting...');
      });

      it('adds disabled class to target', function() {
        $('ul.destroy li .actions .delete-action').click();
        expect($('ul.destroy li .actions .delete-action').hasClass('disabled')).toBeTruthy();
      });
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

  describe('Confirming a delete', function() {
    var subject, confirmed;

    beforeEach(function () {
      fixture.load('confirm-delete.html');
      subject = new $.PMX.ConfirmDelete($('header'),
        {
          confirm: function() {
            confirmed = true;
          }
        });
      subject.init();
    });

    it('injects confirm delete markup', function() {
      expect($('.confirm-delete').length).toBe(1);
    });

    it('wraps original markup in a hideaway class', function() {
      expect($('.hideaway').length).toBe(1);
    });

    describe('and clicking cancel', function() {
      it('removes the hideaway class', function() {
        $('.confirm-delete button.no').trigger($.Event('click'));
        expect($('.hideaway').length).toBe(0)
      });
    });

    describe('and clicking confirm', function() {
      beforeEach(function() {
        $('.confirm-delete button.yes').click();
      });

      it('calls the confirm callback', function() {
        expect(confirmed).toBeTruthy();
      });
    });
  });


});
