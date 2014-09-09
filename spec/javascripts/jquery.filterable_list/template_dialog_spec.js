describe('$.PMX.TemplateDetailsDialog', function() {
  var modalContents,
      urlOption = 'http://localhost/templates/77/details',
      subject;

  beforeEach(function () {
    fixture.load('template-details-dialog.html');
    modalContents = $('#template-details-dialog');
    spyOn($.fn, "dialog");
    spyOn(window, "open");
    subject = new $.PMX.TemplateDetailsDialog('.template-details-link', {url: urlOption, template_id: 77});
    spyOn(subject, "calculateHeight").andCallFake(function() { return 800; });
    subject.init();

  });

  afterEach(function () {
    $('body').css('overflow', 'inherit');
  });

  describe('the dialog is initialized', function() {
    it('calls .dialog on template-details-dialog', function() {
      expect(modalContents.dialog).toHaveBeenCalledWith({
        dialogClass: 'template-details-dialog',
        autoOpen: false,
        modal: true,
        resizable: false,
        draggable: true,
        width: 860,
        height: 800,
        position: ["top", 50],
        title: 'Template Details',
        close: jasmine.any(Function),
        open: jasmine.any(Function),
        buttons: [
          {
            text: "Run Template",
            class: 'button-positive',
            click: jasmine.any(Function)
          },
          {
            text: "Dismiss",
            class: 'button-secondary',
            click: jasmine.any(Function)
          }
        ]
      });
    });
  });

  describe('opening the dialog', function() {
    it('fetches the template details', function() {
      jasmine.Ajax.useMock();
      subject.fetchTemplateDetails();
      var request = mostRecentAjaxRequest();
      expect(request.url).toBe(urlOption);
    });

    it('displays a loading indicator', function() {
      subject.displayLoadingIndicator();
      expect($('#template-details-dialog').html()).toContain('Loading Template Details');
    });
  });

  describe('clicking the Run Template button', function() {
    it('submits the associated template row form', function() {
      var clicked = false;
      $('.template-result form button').on('click', function(e){
        e.preventDefault();
        clicked = true
      });
      subject.handleSubmit($.Event());
      expect(clicked).toBeTruthy();
    });
  });

  describe('closing the dialog', function() {
    it('clears the modal dialog contents', function() {
      subject.handleClose();
      expect($('#template-details-dialog').children().length).toBe(0);
    });
  });
});
