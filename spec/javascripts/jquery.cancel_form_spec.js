describe('$.fn.cancelForm', function () {
  var subject;

  beforeEach(function () {
    fixture.load('cancel_form.html');
    subject = new $.PMX.CancelForm($('a.cancel'));
    subject.init();
  });

  describe('clicking form cancel button', function() {
    it ('clears the text element', function() {
      var element = $('form input[type=text]');
      element.val('Testing');
      $('a.cancel').click();
      expect(element.val()).toEqual('');
    });

    it ('clears the textarea', function() {
      var element = $('form textarea');
      element.val('Testing');
      $('a.cancel').click();
      expect(element.val()).toEqual('');
    });

    it ('clears the select element', function() {
      var element = $('form select');
      element.children().last().prop('selected', true);
      $('a.cancel').click();
      expect($('form select').val()).toEqual('A');
    });
  });
});
