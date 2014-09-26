describe('$.fn.replaceToken', function() {
  var modalContents, subject;

  beforeEach(function () {
    fixture.load('replace-token.html');
    modalContents = $('#update-token-modal');
    spyOn($.fn, "dialog");
    subject = new $.PMX.ReplaceToken($('#template_flow a#token-replace'));
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
        height: 300,
        position: ["top", 30],
        title: 'Replace GitHub Token',
        close: jasmine.any(Function),
        buttons: [
          {
            text: "Save New Token",
            class: 'button-positive',
            click: jasmine.any(Function)
          },
          {
            text: "Cancel",
            class: 'button-secondary',
            click: jasmine.any(Function)
          }
        ]
      });
    });
  });

  describe('clicking the update token link', function() {
    it('prevents default behavior', function() {
      var clickEvent = $.Event('click');
      $('#template_flow a#token-replace').trigger(clickEvent);
      expect(clickEvent.isDefaultPrevented()).toBeTruthy();
    });

    it('displays the modal dialog', function() {
      $('#template_flow a#token-replace').click();
      expect(modalContents.dialog).toHaveBeenCalledWith('open');
    });
  });

  describe('clicking the Save New Token button', function() {
    it('submits the form', function() {
      var submitted = false;
      $('form.update-github-token').on('submit', function(){
        submitted = true;
      });
      subject.initiateDialog();
      subject.handleTokenSave();
      expect(submitted).toBeTruthy();
    });
  });

});
