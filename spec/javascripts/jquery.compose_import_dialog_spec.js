describe('$.fn.composeImportDialog', function() {
  var importLink,
    submitButton,
    subject;

  beforeEach(function() {
    fixture.load('import-compose.html');
    spyOn($.fn, 'dialog').andCallThrough();
    subject = new $.PMX.ApplicationComposeImporter($('section'));
    subject.init();
    importLink = $('a.compose-import');
    submitButton = $('');
  });

  describe('clicking import compose yaml link', function() {
    it('prevents default behavior', function () {
      var clickEvent = $.Event('click');
      importLink.trigger(clickEvent);
      expect(clickEvent.isDefaultPrevented()).toBeTruthy();
    });

    it('initializes content dialog', function() {
      var clickEvent = $.Event('click');
      importLink.trigger(clickEvent);
      expect($('#app-from-compose-modal').dialog).toHaveBeenCalledWith({
        autoOpen: false,
        modal: true,
        resizable: false,
        draggable: true,
        width: 860,
        position: { my: 'top', at: 'top+50', of: window },
        title: 'Run a Docker Compose YAML',
        close: jasmine.any(Function),
        buttons: [
          {
            text: 'Run Compose YAML',
            class: 'button-primary',
            click: jasmine.any(Function)
          }
        ]
      });
    });
  });

 describe('when submitting the form', function () {
   var runButtonClickEvent;

   beforeEach(function () {
     var clickEvent = $.Event('click');

     importLink.trigger(clickEvent);
     runButtonClickEvent = $.Event('click');

     $('form').each(function (i, formObj) {
       spyOn(formObj, 'submit');
     });
     $('button.button-primary').trigger(runButtonClickEvent);
    });

    it('prevents default behavior', function () {
      expect(runButtonClickEvent.isDefaultPrevented()).toBeTruthy();
    });

    it('changes the text of the dialog button to \'Running...\'', function () {
      expect($('button.button-primary span').text()).toEqual('Running...');
    });

    it('disables the dialog button', function () {
      expect($('button.button-primary').closest('button').attr('disabled')).toEqual('disabled');
    });
  });

});
