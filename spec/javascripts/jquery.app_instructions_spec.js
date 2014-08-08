describe('$.fn.appInstructionsDialog', function() {
  var modalContents, subject;

  beforeEach(function () {
    fixture.load('app-instructions.html');
    modalContents = $('#post-run-html');
    spyOn($.fn, "dialog");
    spyOn(window, "open");
    subject = new $.PMX.AppInstructionsDialog($('.instructions-dialog'));
    subject.init();
  });

  afterEach(function () {
    $('body').css('overflow', 'inherit');
  });
  describe('the dialog is initialized', function () {
    it('calls .dialog on post-run-dialog', function () {
      expect(modalContents.dialog).toHaveBeenCalledWith({
        autoOpen: false,
        modal: true,
        resizable: false,
        draggable: true,
        width: 860,
        height: 700,
        position: ["top", 30],
        title: 'Post-Run Instructions',
        close: jasmine.any(Function),
        buttons: [
          {
            text: "Open in New Browser Window",
            class: 'button-primary',
            click: jasmine.any(Function)
          },
          {
            text: "Dismiss",
            class: 'button-secondary',
            click: jasmine.any(Function)
          }
        ]
      });
    });
  });

  describe('clicking the app instructions link', function() {
    it('prevents default behavior', function() {
      var clickEvent = $.Event('click');
      $('.instructions-dialog').trigger(clickEvent);
      expect(clickEvent.isDefaultPrevented()).toBeTruthy();
    });

    it('displays the modal dialog', function() {
      $('.instructions-dialog').click();
      expect(modalContents.dialog).toHaveBeenCalledWith('open');
    });
  });

  describe('clicking the New Browser Window button', function() {
    it('set the new window location to the data-doc-url value', function() {
      subject.initiateDialog();
      subject.handleNewWindowOpen();
      expect(window.open).toHaveBeenCalledWith('http://localhost/applications/77','_blank');
    });
  });

});
