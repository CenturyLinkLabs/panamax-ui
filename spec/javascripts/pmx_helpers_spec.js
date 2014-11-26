describe('$.PMX.Helpers', function() {
  var subject = $.PMX.Helpers;

  describe('.displayError', function() {
    beforeEach(function() {
      fixture.load('site-layout.html');
    });

    it('prepends a notice-danger to the main container by default', function() {
      expect($('main .notice-danger').text()).not.toContain('boom');
      subject.displayError('boom');
      expect($('main .notice-danger').text()).toContain('boom');
    });

    it('can override the style of the notice', function() {
      subject.displayError('boom', { style: 'warning' });
      expect($('main .notice-warning').text()).toContain('boom');
    });

    it('can override the container it will be prepended to', function() {
      subject.displayError('boom', { container: $('#other') });
      expect($('#other .notice-danger').text()).toContain('boom');
    });

    it('can include HTML in the message', function() {
      subject.displayError('This text <marquee>scrolls</marquee>.');
      expect($('main .notice-danger marquee').text()).toEqual("scrolls");
    });
  });
});
