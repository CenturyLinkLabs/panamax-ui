describe('$.fn.editApplicationName', function() {
  var subject;

  beforeEach(function() {
    fixture.load('edit-application-name.html');
    subject = new $.PMX.EditApplicationName($('h1 li:last-of-type'));
    jasmine.Ajax.useMock();
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
    it('submits PUT request to proper url', function() {
      subject.completeEdit({text: 'New Name'});

      var request = mostRecentAjaxRequest();
      request.response({
        status: 200,
        responseText: '{id: 77}'
      });

      expect(request.method).toBe('PUT');
      expect(request.url).toBe('/teaspoon/default');
    });
  });
});
