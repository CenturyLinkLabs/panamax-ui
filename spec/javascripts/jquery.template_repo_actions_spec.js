describe('$.fn.templateRepoActions', function () {
  beforeEach(function () {
    fixture.load('manage-template-repos.html');
    $('.template-repos').templateRepoActions();
    jasmine.Ajax.useMock();
  });

  describe('clicking add source button', function() {
   it ('toggles the form', function () {
     var click = new $.Event('click');
     $('.button-add').trigger(click);
     console.log($('.button-add').html());
     expect($('form').css('display')).toEqual('none');
   });
  });

  describe('clicking delete link', function() {
    it('prevents default behavior', function() {
      var click = new $.Event('click');
      $('.delete-action').trigger(click);
      expect(click.isDefaultPrevented).toBeTruthy();
    });

    it('show the confirm dialog', function() {
      $('.delete-action').click();
      console.log($('.template-repos').html());
      expect($('.confirm-delete').length).toEqual(1);
    });

    it('removes the repo row when delete is confirmed', function() {
      $('delete-action').click();
      console.log($('.template-repos').html());
      $('button.yes').click();

      expect($('ul').length).toEqual(0);
    });
  });
});