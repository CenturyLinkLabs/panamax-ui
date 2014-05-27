describe('$.fn.categoryActions', function() {
  var modalContents,
      addServiceButton,
      subject,
      category_subject,
      edit_category_button;

  beforeEach(function() {
    fixture.load('add-service.html');
    modalContents = $('#add-service-form');
    addServiceButton = $('a.add-service');
    spyOn($.fn, "dialog");
    subject = new $.PMX.AddServiceDialog($('.category-panel'));
    subject.init();
    category_subject = new $.PMX.EditCategory($('.category-panel'));
    category_subject.init();
    edit_category_button = $('.actions a.edit-action');
  });

  afterEach(function() {
    $('body').css('overflow', 'inherit');
  });

  describe('the category edit icon was clicked', function() {
    it('prevents default behavior', function () {
      var clickEvent = $.Event('click');
      edit_category_button.trigger(clickEvent);
      expect(clickEvent.isDefaultPrevented()).toBeTruthy();
    });

    it('hides the parent element', function() {
      var $parent = edit_category_button.parent();

      edit_category_button.trigger('click');
      expect($parent.css('display')).toEqual('none');
    });

    it('creates a content editable element', function() {
      edit_category_button.trigger('click');
      expect($('.content-editable').length).toEqual(1);
    });
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

    it('sets body overflow to hidden', function() {
      expect($('body').css('overflow')).not.toEqual('hidden');
      addServiceButton.click();
      expect($('body').css('overflow')).toEqual('hidden');
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

  describe('selecting a search result', function() {
    var modalContents, callbackReturnVal, subject;

    beforeEach(function() {
      fixture.load('add-service.html');
      jasmine.Ajax.useMock();
      modalContents = $('#add-service-form');
      subject = new $.PMX.AddService(modalContents,
        {
          category: '77',
          $target: $('.category-panel'),
          complete:  function(returnVal) {
            callbackReturnVal = returnVal;
          }
        });
      subject.init();
    });

    it('adds category to form data', function() {
      $('.image-results form').submit();
      var category = modalContents.find('#application_category').val();
      expect(category).toEqual('77');
    });

    it('calls backend service', function(){
      $('.image-results form').submit();

      var request = mostRecentAjaxRequest();
      expect(request.url).toBe('/applications/77/services');
      expect(request.method).toBe('POST');
    });

    it('adds element to services', function(){
      var serviceCount = $('.services li').length;
      $('.image-results form').submit();
      var request = mostRecentAjaxRequest();

      request.response({
        status: 200,
        responseText: '{}'
      });
      var newServiceCount = $('.services li').length;
      expect(newServiceCount).toEqual(serviceCount +1);
    });

    it('displays an icon in the new service li', function() {
      $('.image-results form').submit();
      var request = mostRecentAjaxRequest();

      request.response({
        status: 200,
        responseText: '{}'
      });
      var newElementIcon = $('.services li:last-child .service-icon img').attr('src');
      expect(newElementIcon).toNotBe(undefined);
    });

    it('calls complete callback', function() {
      var serviceCount = $('.services li').length;
      $('.image-results form').submit();
      var request = mostRecentAjaxRequest();

      request.response({
        status: 200,
        responseText: '{}'
      });
      expect(callbackReturnVal).toNotBe(null);
    });
});


});