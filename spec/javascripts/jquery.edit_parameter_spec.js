describe('$.fn.editParameter', function() {
  var subject, element;

  beforeEach(function() {
    fixture.load('edit-parameter.html');
    element = $('dl.entries');
    subject = new $.PMX.EditParameter(element);
    subject.init();
  });

  describe('on click', function() {
    it('prevents default', function() {
      var edit_button = $('.edit-action'),
        clickEvent = $.Event('click');

      edit_button.trigger(clickEvent);
      expect(clickEvent.isDefaultPrevented()).toBeTruthy();
    });

    it('initializes content editable', function() {
      var clickEvent = $.Event('click');

      $('.edit-action').trigger(clickEvent);
      expect($('.content-editable').length).toEqual(1);
    });
  });

  describe('on edit', function() {
    it('sets edited value on hidden field', function() {
      subject.completeEdit({text: 'New Value'});

      expect($('input[data-index=name_0]').val()).toBe('New Value')
    });

    it('enabled the submit button', function() {
      $('form input').attr('disabled', true);
      subject.completeEdit({text: 'New Value'});

      expect($('form input').attr('disabled')).toBeUndefined()
    });

    it('triggers progressiveForm:changed event', function() {
      var triggered = false;
      $('body').on('progressiveForm:changed', function() {
        triggered = true;
      });

      subject.completeEdit({text: 'New Value'});
      expect(triggered).toBeTruthy();
    });
  });
});
