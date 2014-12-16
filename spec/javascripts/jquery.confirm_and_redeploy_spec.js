describe('$.fn.confirmAndRedeploy', function() {
  var subject;

  beforeEach(function() {
    fixture.load('confirm-and-redeploy.html');
    subject = new $.PMX.ConfirmAndRedeploy($('body'));
    subject.init();
  });

  describe('when clicked', function() {
    it('prevents default', function() {
      var click = new $.Event('click');
      $('.redeploy').trigger(click);
      expect(click.isDefaultPrevented).toBeTruthy();
    });

    it('prevents propagation', function() {
      var click = new $.Event('click');
      $('.redeploy').trigger(click);
      expect(click.isPropagationStopped).toBeTruthy();
    });

    it('call createConfirmation', function() {
      var spy = spyOn($.PMX, 'ConfirmDelete').andCallThrough(),
          click = new $.Event('click'),
          $target = $('[data-action-confirm]');
      $target.trigger(click);
      expect(spy).toHaveBeenCalled();
    });
  });
});
