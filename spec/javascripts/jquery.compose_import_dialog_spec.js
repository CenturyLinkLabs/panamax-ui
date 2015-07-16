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
    var tabSpy,
      clickEvent;

    beforeEach(function () {
      tabSpy = spyOn($.fn, 'tabs');
      clickEvent = $.Event('click');
      importLink.trigger(clickEvent);
    });

    it('prevents default behavior', function () {
      expect(clickEvent.isDefaultPrevented()).toBeTruthy();
    });

    it('initializes content dialog', function() {
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

    it('initializes the dialog tabs', function () {
      expect(tabSpy).toHaveBeenCalled();
      expect(tabSpy).toHaveBeenCalledWith({
        heightStyle: 'fill'
      });
    });
  });

  describe('when submitting the form', function () {
    var runButtonClickEvent,
      formSpy;

    beforeEach(function () {
      var clickEvent = $.Event('click');

      importLink.trigger(clickEvent);
      runButtonClickEvent = $.Event('click');

      formSpy = spyOn($.fn, 'submit');
    });

    describe('when the upload tab is active', function () {
      beforeEach(function () {
        $('#app-from-compose-modal #tabs').tabs( 'option', 'active', 0);
        $('button.button-primary').trigger(runButtonClickEvent);
      });

      it('submits the upload form', function () {
        expect(formSpy).toHaveBeenCalled();
        expect(formSpy.mostRecentCall.object.selector).toEqual('#app-from-compose-modal #upload-form');
      });
    });

    describe('when the uri tab is active', function () {
      beforeEach(function () {
        $('#app-from-compose-modal #tabs').tabs( 'option', 'active', 1);
        $('button.button-primary').trigger(runButtonClickEvent);
      });

      it('submits the upload form', function () {
        expect(formSpy).toHaveBeenCalled();
        expect(formSpy.mostRecentCall.object.selector).toEqual('#app-from-compose-modal #uri-form');
      });
    });

    describe('always', function () {
      beforeEach(function () {
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

});
