describe('$.fn.toggleTargetClass', function() {
  beforeEach(function() {
    fixture.load('toggle-target-class.html');
    $('[data-toggle-target]').toggleTargetClass();
  });

  describe('on click', function() {
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
});
