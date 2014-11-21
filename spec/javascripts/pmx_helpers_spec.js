describe('$.PMX.Helpers', function() {
  var subject = $.PMX.Helpers;

  describe('.displayError', function() {
    it('prepends the notice to the main container', function() {
      fixture.load('site-layout.html');
      expect($('main .notice-danger').text()).not.toContain('boom');
      subject.displayError('boom');
      expect($('main .notice-danger').text()).toContain('boom');
    });
  });
});
