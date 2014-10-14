describe('$.fn.registryActions', function () {
  var subject;

  beforeEach(function () {
    fixture.load('manage-registries.html');
    subject = new $.PMX.ManageRegistries($('.registries'));
    subject.init();
  });

  describe('clicking add registry button', function() {
    it ('shows the form if the form is hidden', function () {
      var click = new $.Event('click');
      $('.button-add').trigger(click);
      expect($('form').css('display')).toEqual('block');
    });

    it ('hides the form if the form is visible', function () {
      var click = new $.Event('click');
      $('form').css('display', 'block');
      $('.button-add').trigger(click);
      expect($('form').css('display')).toEqual('none');
    });
  });

  describe('clicking the delete X', function() {
    it('prevents default behavior', function() {
      var click = new $.Event('click');
      $('.delete-action').trigger(click);
      expect(click.isDefaultPrevented).toBeTruthy();
    });

    it('shows the confirm dialog', function() {
      $('a.delete-action').click();
      expect($('.confirm-delete').length).toEqual(1);
    });

    it('removes the registry row when delete is confirmed', function() {
      spyOn(subject, 'confirmDelete');
      $('a.delete-action').click();
      $('button.yes').click();

      expect(subject.confirmDelete).toHaveBeenCalled();
    });
  });
});
