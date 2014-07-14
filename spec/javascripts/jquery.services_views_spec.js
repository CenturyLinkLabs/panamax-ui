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

  describe('sorting categories', function() {
    var dragUI, subject;

    beforeEach(function() {
      fixture.load('sorting-categories.html');
      dragUI = {
        item: $('div.category-panel').first(),
        placeholder: $('<div></div>')
      };

      subject = new $.PMX.SortCategories($('.views'));
      subject.init();
      jasmine.Ajax.useMock();
    });

    it('custom placeholder will not have category-panel', function() {
      subject.startDrag($.Event(), dragUI);
      expect(dragUI.placeholder.hasClass('category-panel')).toBeFalsy();
    });

    it('sends  PUT request to proper url', function() {
      var evt = $.Event('drop');

      subject.drop(evt,dragUI);
      var request = mostRecentAjaxRequest();
      expect(request.url).toEqual('/teaspoon/default/categories/2');
      expect(request.method).toEqual('PUT');
    });

    it('put category-panel back after dropping', function() {
      var evt = $.Event('drop');

      subject.drop(evt,dragUI);
      expect(dragUI.item.hasClass('category-panel')).toBeTruthy();
    });
  });

});
