describe('$.fn.selectDeploymentTarget', function () {
  var subject,
      fakeResponse = '<div class="select-remote-target">Booyah!</div>'
  beforeEach(function () {
    fixture.load('select-deployment-target.html');
    subject = new $.PMX.SelectDeploymentTarget($('.remote-deployment'));
    spyOn($.fn, 'dialog').andReturn({ dialog: function() {} });
    subject.init();
    jasmine.Ajax.useMock();
  });

  describe('when clicking on a remote deployment link', function() {
    it('prevents default', function() {
      var link = $('.remote-deployment a'),
        clickEvent = $.Event('click');

      link.trigger(clickEvent);
      expect(clickEvent.isDefaultPrevented()).toBeTruthy();
    });

    it('triggers the dialog', function() {
      $('.remote-deployment a').click();
      var request = mostRecentAjaxRequest();

      request.response({
        status: 200,
        responseText: fakeResponse
      });

      expect($.fn.dialog).toHaveBeenCalledWith({
        autoOpen: false,
        modal: true,
        resizable: false,
        draggable: true,
        width: 860,
        position: { my: "top", at: "top+50", of: window },
        title: 'Select Remote Deployment Target',
        close: jasmine.any(Function),
        buttons: [
          {
            text: "Dismiss",
            class: 'button-secondary',
            click: jasmine.any(Function)
          }
        ]
      });
    });
  });
});
