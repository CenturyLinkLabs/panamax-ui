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
        var $toggler = $('a.toggler');

        expect($target.hasClass('collapsed')).toBe(false);
        $toggler.click();
        expect($target.hasClass('collapsed')).toBe(true);
        $toggler.click();
        expect($target.hasClass('collapsed')).toBe(false);
      });
    });

    describe('when the target is not supplied', function() {
      it('toggles the specified class', function() {
        var $toggler = $('a.toggler-no-target');

        expect($toggler.hasClass('collapsed')).toBe(false);
        $toggler.click();
        expect($toggler.hasClass('collapsed')).toBe(true);
        $toggler.click();
        expect($toggler.hasClass('collapsed')).toBe(false);
      });
    });

  });
});
