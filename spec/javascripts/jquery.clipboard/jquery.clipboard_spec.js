describe('$.fn.clipboard', function() {
  var subject, afterCalled;

  beforeEach(function() {
    fixture.load('clipboard.html');
    afterCalled = false;
    spyOn(window, 'ZeroClipboard').andReturn({
      on: function(name, callback) {
       callback();
      }
    });
  });

  describe('when copy is complete', function() {
    it('calls default afterCopy method', function() {
      subject = new $.PMX.Clipboard($('[data-clipboard-text]'));
      subject.init();
      expect($('.clippy a').text()).toEqual('Token Copied to Clipboard');
    });

    it('calls afterCopy callback when provided', function() {
      subject = new $.PMX.Clipboard($('[data-clipboard-text]'), {
        afterCopy: function() {
          afterCalled = true;
        }
      });
      subject.init();
      expect(afterCalled).toBeTruthy();
    });
  });
});
