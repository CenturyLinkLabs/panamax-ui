describe('$.fn.categoryActions', function() {
  var modalContents, addServiceButton;

  beforeEach(function() {
    fixture.load('add-service.html');
    modalContents = $('#add-service-form');
    addServiceButton = $('a.add-service');
    spyOn($.fn, "dialog");
    $('.category-panel').categoryActions();
  });

  describe('the dialog is initialized', function() {
    it('calls .dialog on the add service form', function() {
      expect(modalContents.dialog).toHaveBeenCalledWith({
        autoOpen: false,
        modal: true,
        resizable: false,
        draggable: true,
        width: 860,
        position: ["top", 50],
        title: 'Search Images',
        buttons: [
          {
            text: "Cancel",
            class: 'button-secondary',
            click: jasmine.any(Function)
          }
        ]
      });
    });
  });

  describe('clicking add service button', function() {
    it('prevents default behavior', function() {
      var clickEvent = $.Event('click');
      addServiceButton.trigger(clickEvent);
      expect(clickEvent.isDefaultPrevented()).toBeTruthy();
    });

    it('displays the add service form in a modal window', function() {
      addServiceButton.click();
      expect(modalContents.dialog).toHaveBeenCalledWith('open');
    });

  });

  describe('clicking the search button displays results', function() {

  });

});