describe('$.fn.remoteContentsDialog', function() {
  var subject,
      fakeModal;

  beforeEach(function() {
    fixture.load('remote_contents_modal.html');
    fakeModal = jasmine.createSpyObj('modal', ['dialog']);
    spyOn($.PMX.Helpers, 'dialog').andReturn(fakeModal);
    subject = new $.PMX.RemoteContentsDialog($('body'), {
      targetSelector: '#modal_launcher'
    });
  });

  describe('clicking the trigger', function() {
    beforeEach(function() {
      jasmine.Ajax.useMock();
      subject.init();
    });

    it('makes an ajax request to the URL from the link', function() {
      $('a#modal_launcher').click();

      var request = mostRecentAjaxRequest();
      expect(request.url).toEqual('foo.com/bar');
    });

    it('triggers the modal with the remote contents', function() {
      $('a#modal_launcher').click();

      var request = mostRecentAjaxRequest();
      request.response({
        status: 200,
        responseText: '<div class="plain-contents">response content</div>'
      });

      expect($.PMX.Helpers.dialog).toHaveBeenCalledWith(
        jasmine.any(Object),
        jasmine.any(jQuery),
        { title: '' },
        true
      );

      expect(fakeModal.dialog).toHaveBeenCalledWith('open');
    });
  });

});
