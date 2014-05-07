describe('$.fn.progressiveForm', function() {
  var subject,
      $form;

  beforeEach(function() {
    fixture.load('progressive-form.html');
    $form = $('#teaspoon-fixtures').find('form');
    subject = new $.PMX.ProgressiveForm($form);
  });

  describe('instantiation', function() {
    it('hides all form elements', function() {
      expect($form.find('input:hidden').length).toBe(0);
      subject.init();
      expect($form.find('input:hidden').length).toBe(2);
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

    it('unchecks the linked checkbox', function() {
      var $checkbox = $form.find('input#linked_checkbox')
      expect($checkbox.prop('checked')).toEqual(true)
      $form.find('a').click()
      expect($checkbox.prop('checked')).toEqual(false)
    });

    it('submits the form', function() {
      $form.find('a').click()
      expect($form.submit).toHaveBeenCalled();
    });
  });
});
