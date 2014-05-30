describe('$.fn.ApplicationMenuActions', function () {
  beforeEach(function() {
    fixture.load('application-header.html');
    $('header.application').applicationMenuActions();
    spyOn($.fn, "slideToggle");
  });

  describe('clicking the application menu button', function () {

    var clickEvent = $.Event('click');

    it('toggles the menu', function () {
      $('a.options').trigger(clickEvent);
      expect($('a.options').slideToggle).toHaveBeenCalled();
    });

  });
});
