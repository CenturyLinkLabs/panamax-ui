describe('$.fn.categoryActions', function() {
  var modalContents, addServiceButton, subject;

  beforeEach(function() {
    fixture.load('add-service.html');
    modalContents = $('#add-service-form');
    addServiceButton = $('a.add-service');
    spyOn($.fn, "dialog");
    subject = new $.PMX.AddService($('.category-panel'));
    subject.init();
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
        close: jasmine.any(Function),
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

  describe('closing dialog', function() {
    it('removes previous search input', function(){
      $('#search_form_query').val('testing');
      subject.handleClose();
      expect($('#search_form_query').val()).toBe('');
    });

    it('removes previous search results', function() {
      $('<div>test</div>').appendTo('.image-results');
      subject.handleClose();
      expect($('.image-results').children().length).toBe(0);
    });

  });

});