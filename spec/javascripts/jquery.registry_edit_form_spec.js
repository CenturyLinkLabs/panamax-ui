describe('$.fn.registryEditForm', function() {
  var subject,
      $form;

  beforeEach(function() {
    jasmine.Ajax.useMock();
    fixture.load('registry-edit-form.html');
    $form = $('#teaspoon-fixtures').find('form');
    subject = new $.PMX.RegistryEditForm($form);
  });

  describe('checking an attribute in the form', function() {
    beforeEach(function() {
      subject.init();
    });

    it('sends an ajax request with the serialized form contents', function() {
      $form.find('input[type="checkbox"]').prop('checked', true).trigger('change');
      var request = mostRecentAjaxRequest();
      expect(request.method).toEqual('PUT')
      expect(request.params).toEqual('boom=0&boom=1')
      expect(request.url).toEqual('/boom/shaka')
    });
  });

  describe('unchecking an attribute in the form', function() {
    beforeEach(function() {
      $form.find('input[type="checkbox"]').prop('checked', true);
      subject.init();
    });

    it('sends an ajax request with the serialized form contents', function() {
      $form.find('input[type="checkbox"]').prop('checked', false).trigger('change');
      var request = mostRecentAjaxRequest();
      expect(request.params).toEqual('boom=0')
    });
  });
});
