describe('$.fn.serviceViews', function () {
  beforeEach(function () {
    fixture.load('service-view-toggle.html');
    $('section.application-services').serviceViews();
    $listView = $('#teaspoon-fixtures').find('.list');
    $relationshipView = $('#teaspoon-fixtures').find('.relationship');
    jasmine.Ajax.useMock();
  });

  describe('clicking list view', function() {
    it('adds .selected class', function() {
      expect($listView.hasClass('selected')).toBeFalsy();
      $listView.click();
      expect($listView.hasClass('selected')).toBeTruthy();
    });

    it('removes .selected class from other links', function() {
      $relationshipView.addClass('selected');
      $listView .click();
      expect($relationshipView.hasClass('selected')).toBeFalsy();
    });
  });

  describe('clicking relationship view', function() {
    it('adds .selected class', function() {
      expect($relationshipView.hasClass('selected')).toBeFalsy();
      $relationshipView.click();
      expect($relationshipView.hasClass('selected')).toBeTruthy();
    });

    it('removes .selected class from other links', function() {
      $listView.addClass('selected');
      $relationshipView.click();
      expect($listView.hasClass('selected')).toBeFalsy();
    });
  });
});
