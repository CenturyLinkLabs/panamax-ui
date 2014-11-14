describe('$.fn.updatableContents', function() {
  var $el,
      refreshClass = 'contents-refreshed';

  beforeEach(function() {
    jasmine.Ajax.useMock();
    fixture.load('updatable-contents.html');

    $el = $('.updatable-item');

    $el.updatableContents({
      targetSelector: 'a.trigger',
      refreshedClass: refreshClass,
      urlDataAttribute: 'url',
      template: Handlebars.compile($('#updatable_item_template').html())
    });
  });

  describe('clicking the trigger', function() {
    it('updates the contents with those from the template and adds the refreshed class', function() {
      var successMessage = 'successfully refreshed';

      expect($('.updatable-item p').text()).not.toEqual(successMessage);
      expect($el.hasClass(refreshClass)).toBe(false)

      $('.trigger').click();

      var request = mostRecentAjaxRequest();
      request.response({
        status: 200,
        responseText: JSON.stringify({message: successMessage })
      });

      expect($('.updatable-item p').text()).toEqual(successMessage);
      expect($el.hasClass(refreshClass)).toBe(true)
    });

    it('does not make a call if the refreshedClass is set', function() {
      $el.addClass(refreshClass);

      var beforeCallCount = ajaxRequests.length
      $('.trigger').click();
      var afterCallCount = ajaxRequests.length
      expect(afterCallCount - beforeCallCount).toEqual(0)
    });
  });

});
