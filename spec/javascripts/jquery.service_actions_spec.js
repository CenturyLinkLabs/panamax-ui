describe('$.fn.serviceActions', function () {
  var serviceEventCalled = true;

  beforeEach(function () {
    fixture.load('manage-service.html');
    $('ul.services li').serviceActions();
    $('ul.services').on('category-change', function() {
      serviceEventCalled = true;
    });
    jasmine.Ajax.useMock();
  });

  describe('clicking remove service', function() {
    it('issues the delete', function() {
      $('ul.services li:first-child .actions .delete-action').click();
      var request = mostRecentAjaxRequest();
      expect(request.url).toBe('/apps/1/services/1');
      expect(request.method).toBe('DELETE');
    });

    it('prevents default behavior', function() {
      var clickEvent = $.Event('click');
      $('ul.services li:first-child .actions .delete-action').trigger(clickEvent);
      expect(clickEvent.isDefaultPrevented()).toBeTruthy();
    });

    it('hides the dom element', function() {
      $('ul.services li:first-child .actions .delete-action').click();
      var request = mostRecentAjaxRequest();

      request.response({
        status: 200,
        responseText: '{}'
      });

      expect($('ul.services li').css('opacity')).toBe('0.5');
      // Testing opacity because animations have been turned off
    });

    it ('triggers category-change event ', function() {
      var request = mostRecentAjaxRequest();

      request.response({
        status: 200,
        responseText: '{}'
      });
      $('ul.services li .actions .delete-action').click();

      expect(serviceEventCalled).toBeTruthy();
    });
  });

  describe('hovering over a service name', function() {

    var mouseenter = new $.Event('mouseenter');
    var mouseleave = new $.Event('mouseleave');
    var mousedown = new $.Event('mousedown');

    it('adds a tooltip if the name is too long for UI display', function () {
      $('ul.services li:last-child a:first-child').trigger(mouseenter);
      expect($('ul.services li:last-child').html()).toContain('tooltip');
    });

    it('does not show a tooltip if name is short', function () {
      $('ul.services li:first-child a:first-child').trigger(mouseenter);
      expect($('ul.services li:first-child').html()).toNotContain('tooltip');
    });

    it('removes an existing tooltip on mouseleave', function () {
      $('ul.services li:last-child a:first-child').trigger(mouseenter);
      expect($('ul.services li:last-child').html()).toContain('tooltip');
      $('ul.services li:last-child a:first-child').trigger(mouseleave);
      expect($('ul.services li:last-child').html()).toNotContain('tooltip');
    });

    it('removes an existing tooltip on mousedown (dragging)', function () {
      $('ul.services li:last-child a:first-child').trigger(mouseenter);
      expect($('ul.services li:last-child').html()).toContain('tooltip');
      $('ul.services li:last-child').trigger(mousedown);
      expect($('ul.services li:last-child').html()).toNotContain('tooltip');
    });

  });
});
