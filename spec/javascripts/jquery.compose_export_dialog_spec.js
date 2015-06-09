describe('$.fn.composeExportDialog', function() {
  var exportLink,
    subject;

  beforeEach(function() {
    fixture.load('export-compose.html');
    spyOn($.fn, 'dialog').andCallThrough();
    subject = new $.PMX.ApplicationComposeExporter($('section'));
    subject.init();
    exportLink = $('a.export');
    jasmine.Ajax.useMock();
  });

  describe('clicking export compose yaml link', function() {
    it('prevents default behavior', function () {
      var clickEvent = $.Event('click');
      exportLink.trigger(clickEvent);
      expect(clickEvent.isDefaultPrevented()).toBeTruthy();
    });

    it('retrieves the compose yaml', function() {
      exportLink.click();
      var request = mostRecentAjaxRequest();
      expect(request.url).toEqual('/apps/11/compose_yml');
    });
  });

  describe('when compose yaml request returns', function() {
    it('initializes content dialog', function() {
      subject.triggerExport($.Event());
      var request = mostRecentAjaxRequest();

      request.response({
        status: 200,
        responseText: JSON.stringify({compose_yaml: '---\n'})
      });

      expect($('pre').dialog).toHaveBeenCalledWith({
        autoOpen: false,
        modal: true,
        resizable: false,
        draggable: true,
        width: 860,
        position: { my: 'top', at: 'top+50', of: window },
        title: 'Docker Compose YAML',
        close: jasmine.any(Function),
        buttons: [
          {
            text: 'Dismiss',
            class: 'button-secondary',
            click: jasmine.any(Function)
          }
        ]
      });
    });
  });
});
