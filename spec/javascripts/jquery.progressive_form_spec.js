describe('$.fn.progressiveForm', function() {
  var subject,
      $form;

  beforeEach(function() {
    fixture.load('progressive-form.html');
    $form = $('#teaspoon-fixtures').find('form');
    subject = new $.PMX.ProgressiveForm($form);
  });

  describe('instantiation', function() {
    it('hides all checkbox elements', function() {
      expect($form.find('input:hidden').length).toBe(0);
      subject.init();
      expect($form.find('input:hidden').length).toBe(1);
    });

    it('disables the submit button', function() {
      expect($form.find('input[type="submit"]').prop('disabled')).toBe(false);
      subject.init();
      expect($form.find('input[type="submit"]').prop('disabled')).toBe(true);
    });
  });

  describe('changing a value in the form', function() {
    beforeEach(function() {
      subject.init();
    });

    it('enables the submit button when changing a select', function() {
      expect($form.find('input[type="submit"]').prop('disabled')).toBe(true);
      $form.find('select').change();
      expect($form.find('input[type="submit"]').prop('disabled')).toBe(false);
    });

    it('enables the submit button when entering text in an input', function() {
      expect($form.find('input[type="submit"]').prop('disabled')).toBe(true);
      $form.find('input[type="number"]').keyup();
      expect($form.find('input[type="submit"]').prop('disabled')).toBe(false);
    });

    it('enables the submit button when entering text in a text area', function() {
      expect($form.find('input[type="submit"]').prop('disabled')).toBe(true);
      $form.find('textarea').keyup();
      expect($form.find('input[type="submit"]').prop('disabled')).toBe(false);
    });
  });

  describe('clicking a delete link', function() {
    beforeEach(function() {
      spyOn($form, 'submit');
      subject.init();
    });

    it('prevents the default behavior', function() {
      var clickEvent = $.Event('click');
      $form.find('a').trigger(clickEvent);
      expect(clickEvent.isDefaultPrevented()).toBeTruthy();
    });

    it('checks the linked checkbox', function() {
      var $checkbox = $form.find('input#linked_checkbox')
      expect($checkbox.prop('checked')).toEqual(false)
      $form.find('a').click()
      expect($checkbox.prop('checked')).toEqual(true)
    });

    it('submits the form', function() {
      $form.find('a').click()
      expect($form.submit).toHaveBeenCalled();
    });
  });
});
