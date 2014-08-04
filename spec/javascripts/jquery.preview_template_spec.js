describe('$.fn.previewTemplate', function() {
  var subject, button;

  beforeEach(function() {
    fixture.load('template-preview.html');
    subject = new $.PMX.PreviewTemplate($('.preview-form .preview'));
    button = $('.preview-form .preview');
    spyOn($.fn, "dialog").andCallThrough();
    jasmine.Ajax.useMock();
    subject.init();
  });

  describe('on click', function() {
    it('prevents default', function() {
      var clickEvent = $.Event('click');
      button.trigger(clickEvent);
      expect(clickEvent.isDefaultPrevented()).toBeTruthy();
    });

    it('retrieves the template preview', function() {
      button.click();
      var request = mostRecentAjaxRequest();
      expect(request.url).toEqual('/apps/11/template')
    });

    it('submits the template form data', function() {
      button.click();
      var request = mostRecentAjaxRequest();
      expect(request.params).toContain('description=testing');
    });

    it('strips the trailing whitespace from documentation', function() {
      var theForm = $('form.preview-form'),
          strippedForm;

      spyOn(theForm, 'serializeArray').andCallFake(function() {
        return [{name:'documentation', value: 'line1  \n\nline2 \r\nline3' }];
      });

      strippedForm = subject.serializeFormAndFixDocumentation(theForm);
      expect(strippedForm).toContain('documentation=line1%0A%0Aline2%0Aline3');
    });
  });

  describe('when preview request returns', function() {
    it('initializes content dialog', function() {
      subject.triggerPreview($.Event());
      var request = mostRecentAjaxRequest();

      request.response({
        status: 200,
        responseText: JSON.stringify({template: 'Template Preview'})
      });

      expect($('pre').dialog).toHaveBeenCalledWith({
        autoOpen: false,
        modal: true,
        resizable: false,
        draggable: true,
        width: 860,
        position: ["top", 50],
        title: 'Template File Preview',
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
