describe('$.fn.composeExportDialog', function() {
  var exportLink,
    subject,
    clipboard = jasmine.createSpyObj('zeroclipboard', ['clip', 'setText', 'on']);

  beforeEach(function() {
    fixture.load('export-compose.html');
    spyOn($.fn, 'dialog').andCallThrough();
    spyOn(window, 'ZeroClipboard').andReturn(clipboard);
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

    it('sets the download url into the options', function () {
      exportLink.click();
      expect(subject.options.downloadUrl).toEqual('http://localhost/apps/11/compose_download.yaml');
    });
  });

  describe('when compose yaml request returns', function() {
    beforeEach(function () {
      subject.triggerExport($.Event());
      var request = mostRecentAjaxRequest();

      request.response({
        status: 200,
        responseText: JSON.stringify({compose_yaml: '---\n'})
      });
    });

    it('initializes content dialog', function() {
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
            text : 'Save as Local File',
            class : 'button-primary download',
            click : jasmine.any(Function)
          },
          {
            text: 'Inspect & Validate in Lorry.io',
            class: 'link lorry-export',
            click: jasmine.any(Function)
          },
          {
            text: 'Copy to Clipboard',
            class: 'link clipboard-copy',
            click: jasmine.any(Function)
          }
        ]
      });
    });

    describe('the zeroclipboard plugin is setup', function () {
      it('attaches to the clipboard-copy button', function () {
        expect(clipboard.clip).toHaveBeenCalledWith($('.clipboard-copy'));
      });

      it('sets the text to the compose_yaml in the api response', function () {
        expect(clipboard.setText).toHaveBeenCalledWith('---\n');
      });

      it('sets the aftercopy handler', function () {
        expect(clipboard.on).toHaveBeenCalledWith('aftercopy', subject.afterCopy);
      });
    });
  });

  describe('when the user has clicked to save the compose yaml as a local file', function () {
    beforeEach(function () {
      spyOn(window, 'open');
      subject.options.downloadUrl = 'http://localhost/apps/11/compose_download.yaml';
      subject.handleDownload();
    });

    it('redirects to the download url', function () {
      expect(window.open).toHaveBeenCalledWith('http://localhost/apps/11/compose_download.yaml','_blank');
    });
  });

  describe('after the content has been copied', function () {
    var button;

    beforeEach(function () {
      button = $('<button>Copy to Clipboard</button>');
      subject.afterCopy({ target: button });
    });

    it('adds the "copied" class to the copy button', function () {
      expect($(button).hasClass('copied')).toEqual(true);
    });

    it('changes the text of the copy button', function () {
      expect($(button).text()).toEqual('YAML Copied to Clipboard');
    });
  });

  describe('when the user chooses to view the compose yaml in lorry', function () {
    beforeEach(function () {
      subject.confirmGistCreation();
    });

    it('sets the yaml output element display to hidden', function () {
      expect($('.prettyprint').css('visibility')).toBe('hidden');
    });

    it('opens a confirmation dialog', function () {
      expect($('#gistConfirmationDialog').dialog).toHaveBeenCalledWith({
        autoOpen: true,
        dialogClass: 'dialog-dialog',
        maxHeight: 500,
        modal: true,
        resizable: false,
        draggable: false,
        width: 860,
        position: { my: 'top', at: 'top+50', of: window },
        close: jasmine.any(Function)
      });
    });

    describe('when the user confirms the export', function () {
      beforeEach(function () {
        spyOn(subject, 'handleClose');
        subject.confirmExport();
      });

      it('closes the confirmation dialog', function () {
        expect($('#gistConfirmationDialog').dialog).toHaveBeenCalledWith('close');
      });

      it('closes the yaml export dialog', function () {
        expect(subject.handleClose).toHaveBeenCalled();
      });
    });

    describe('when the user cancels the export', function () {
      beforeEach(function () {
        subject.cancelExport();
      });

      it('closes the confirmation dialog', function () {
        expect($('#gistConfirmationDialog').dialog).toHaveBeenCalledWith('close');
      });

      it('sets the yaml output element display to visible', function () {
        expect($('.prettyprint').css('visibility')).toBe('visible');
      });
    });
  });

});
