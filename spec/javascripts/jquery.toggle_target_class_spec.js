describe('$.fn.toggleTargetClass', function() {
  beforeEach(function() {
    fixture.load('toggle-target-class.html');
    $('body').off('click');
    $('body').toggleTargetClass();
  });

  describe('on click', function() {
    describe('when the target is supplied', function() {

      it('toggles the specified class', function() {
        var $target = $('.target-container');
        var $toggler = $('div.toggler');

        expect($target.hasClass('collapsed')).toBe(false);
        $toggler.click();
        expect($target.hasClass('collapsed')).toBe(true);
        $toggler.click();
        expect($target.hasClass('collapsed')).toBe(false);
      });
    });

    describe('when the target is not supplied', function() {
      it('toggles the specified class', function() {
        var $toggler = $('div.toggler-no-target');

        expect($toggler.hasClass('collapsed')).toBe(false);
        $toggler.click();
        expect($toggler.hasClass('collapsed')).toBe(true);
        $toggler.click();
        expect($toggler.hasClass('collapsed')).toBe(false);
      });
    });

    describe('when clicking links within the target', function () {

      it('prevents default event action for links not containing the passthru data attribute', function () {
        var evt = $.Event('click');
        var link = $('.toggler a.no-passthru');
        link.trigger(evt);
        expect(evt.isDefaultPrevented()).toBeTruthy();
      });

      it('allows default event action for links with the passthru data attribute', function () {
        var evt = $.Event('click');
        var link = $('.toggler a.passthru');
        link.trigger(evt);
        expect(evt.isDefaultPrevented()).toBeFalsy();
      });
    });

  });
});
