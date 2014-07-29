describe('$.fn.filterableList', function() {
  var fakeSearchResults;

  function createFakeSearchResults() {
    var dummyTemplates = [
      {
        title: 'some template',
        description: 'this template will change your life',
        id: 77
      }
    ],
    dummyLocalImages = [
      {
        description:"a local image",
        title:"local/image",
        id:"dlacewell/local"
      }
    ],
    dummyRemoteImages = [
      {
        description:"some description",
        title:"some/name",
        id:"dlacewell/asdf"
      }
    ];

    return {
      fetch: function() {},
      templates: function(callback) { callback.call(this, dummyTemplates) },
      localImages: function(callback) { callback.call(this, dummyLocalImages) },
      remoteImages: function(callback) { callback.call(this, dummyRemoteImages) }
    }
  };

  beforeEach(function() {
    fixture.load('search.html');
    fakeSearchResults = createFakeSearchResults();
    spyOn(fakeSearchResults, 'fetch');
    spyOn($.PMX, 'SearchResults').andReturn(fakeSearchResults);
    spyOn(PMX.Tracker, 'trackEvent');
    $('.filterable-list').filterableList();
  });

  describe('submitting the form', function() {
    it('displays the loading indicator', function() {
      // don't trigger callbacks
      spyOn(fakeSearchResults, 'templates');
      spyOn(fakeSearchResults, 'localImages');
      spyOn(fakeSearchResults, 'remoteImages');

      expect($('.in-progress').length).toEqual(0);
      $('input.query-field').val('mys');
      $('.filterable-list form').submit();
      expect($('.in-progress').length).toEqual(3);
    });

    it('prevents default behavior', function() {
      var submitEvent = $.Event('submit');
      $('.filterable-list form').trigger(submitEvent);
      expect(submitEvent.isDefaultPrevented()).toBeTruthy();
    });

    it('requests results', function() {
      $('input.query-field').val('mys');
      $('.filterable-list form').submit();

      expect(fakeSearchResults.fetch).toHaveBeenCalledWith('mys');
    });

    it('displays the search headings', function() {
      $('h3.search-title').hide();
      $('.filterable-list form').submit();
      expect($('h3.search-title:visible').length).toEqual(2);
    });

    it('records the term search for and sends to the NSA', function() {
      $('input.query-field').val('mysql');
      $('.filterable-list form').submit();
      expect(PMX.Tracker.trackEvent).toHaveBeenCalledWith('search', 'not-given', 'mysql');
    });
  });

  describe('changing the text in the query field', function() {

    it('does not request results if fewer than 3 characters exist', function() {
      $('input.query-field').val('my').keyup();

      expect(fakeSearchResults.fetch).not.toHaveBeenCalled();
    });

    it('does not re-request results if the value has not actually changed', function() {
      $('input.query-field').val('word').keyup();
      $('input.query-field').val('word').keyup();

      expect(fakeSearchResults.fetch.calls.length).toEqual(1);
    });

    it('displays the search headings', function() {
      $('h3.search-title').hide();
      $('input.query-field').val('word').keyup();
      expect($('h3.search-title:visible').length).toEqual(2);
    });

    it('requests results when the searchfield is changed', function() {
      $('input.query-field').val('mys').keyup();

      var request = mostRecentAjaxRequest();
      expect(fakeSearchResults.fetch).toHaveBeenCalledWith('mys');
    });

    it('places the results on the page', function() {
      $('input.query-field').val('apache').keyup();

      expect($('.remote-image-results').html()).toContain('some/name');
      expect($('.remote-image-results').html()).toContain('some description');
      expect($('.local-image-results').html()).toContain('local/image');
      expect($('.local-image-results').html()).toContain('a local image');
      expect($('.template-results').html()).toContain('some template')
      expect($('.template-results').html()).toContain('this template will change your life')
    });

    it('calls chosen on the tags dropdown once the element is added to the page', function() {
      $('input.query-field').val('apache').keyup();

      expect($('.local-image-results').html()).toContain('chosen-container');
    });

    it('says sorry if it cannot find a template', function() {
      spyOn(fakeSearchResults, 'templates').andCallFake(function(callback) {
        callback.call(this, []);
      });

      $('input.query-field').val('apache').keyup();

      expect($('.template-results').html()).toContain('sorry, nothin here');
    });
  });

  describe('searching for anything', function() {
    it('shows the source repo blurb if it finds a template', function() {
      $('input.query-field').val('apache').keyup();

      expect($('.template-results').html()).toContain('This is some information about how users can create their own templates');
    });

    it('shows the source repo blurb if it cannot find a template', function() {
      spyOn(fakeSearchResults, 'templates').andCallFake(function(callback) {
        callback.call(this, []);
      });

      $('input.query-field').val('apache').keyup();

      expect($('.template-results').html()).toContain('This is some information about how users can create their own templates');
    });

  });

  describe('clicking on the tags dropdown', function() {
    beforeEach(function() {
      jasmine.Ajax.useMock();
    });

    it('ajax loads tags if they are not already loaded', function() {
      $('input.query-field').val('apache').keyup();

      $('.chosen-container').first().click();

      request = mostRecentAjaxRequest();
      request.response({
        status: 200,
        responseText: JSON.stringify(['foo', 'bar'])
      });

      expect($('select.image-tag-select').first().data('loaded')).toBe(true);
      expect($('select.image-tag-select').first().children().length).toNotEqual(0);
    });

    it('does not ajax load tags if they are already loaded', function() {
      $('input.query-field').val('apache').keyup();
      var $tagsSelect = $('select.image-tag-select').first();
      $tagsSelect.attr('data-loaded', true);
      $('.chosen-container').first().click();

      expect($tagsSelect.children().length).toEqual(1);
    });
  });

  describe('clicking the template details link', function() {

    beforeEach(function() {
      $('input.query-field').val('mys');
      $('.filterable-list form').submit();
    });

    it('prevents default behavior', function() {
      var clickEvent = $.Event('click');
      $('.template-details-link').trigger(clickEvent);
      expect(clickEvent.isDefaultPrevented()).toBeTruthy();
    });

    describe('initializing the dialog', function(){
      beforeEach(function(){
        spyOn($.PMX, "TemplateDetailsDialog").andCallFake(function($el, options) {
          return {
            init: function() {},
            showTemplateDialog: function() {}
          }
        });
      });

      it('instantiates the modal dialog', function() {
        $('.template-details-link').click();
        expect($.PMX.TemplateDetailsDialog).toHaveBeenCalled();
      });

      it('passes the base dom element and the details url to the modal dialog', function() {
        $('.template-details-link').click();
        var args = $.PMX.TemplateDetailsDialog.mostRecentCall.args;
        expect(args[0]).toEqual('.template-details-link');
        expect(args[1]['url']).toMatch("/templates/77/details$")
      });

    });

    it('displays the modal dialog', function() {
      spyOn($.fn, "dialog");
      spyOn(window, "open");
      var modalContents = $('#template-details-dialog');
      $('.template-details-link').click();
      expect(modalContents.dialog).toHaveBeenCalledWith('open');
    });
  });

});

describe('$.PMX.SearchResults', function() {
  var subject;
  beforeEach(function() {
    jasmine.Ajax.useMock();
    subject = new $.PMX.SearchResults('some/url', 20);
  });

  describe('#fetch', function() {
    it('fetches templates for the supplied term', function() {
      subject.fetch('apache');
      var request = ajaxRequests[ajaxRequests.length-3];
      expect(request.url).toBe('some/url?search_result_set%5Bq%5D=apache&search_result_set%5Btype%5D=template&search_result_set%5Blimit%5D=20');
    });

    it('fetches local images for the supplied term', function() {
      subject.fetch('apache');
      var request = ajaxRequests[ajaxRequests.length-2];
      expect(request.url).toBe('some/url?search_result_set%5Bq%5D=apache&search_result_set%5Btype%5D=local_image&search_result_set%5Blimit%5D=20');
    });

    it('fetches remote images for the supplied term', function() {
      subject.fetch('apache');
      var request = mostRecentAjaxRequest();
      expect(request.url).toBe('some/url?search_result_set%5Bq%5D=apache&search_result_set%5Btype%5D=remote_image&search_result_set%5Blimit%5D=20');
    });

    it('aborts the previous requests', function() {
      var fakeXhr = {
        abort: function() {},
        done: function() { return fakeXhr; }
      };
      spyOn(fakeXhr, 'abort');

      subject.templatesXhr = fakeXhr;
      subject.localImagesXhr = fakeXhr;
      subject.remoteImagesXhr = fakeXhr;
      subject.fetch('apache');

      expect(fakeXhr.abort.calls.length).toEqual(3);
    });
  });

  describe('#templates', function() {
    it('calls the supllied callback when the templates request resolves', function() {
      var callback = jasmine.createSpy('templates callback');
      subject.fetch('apache');
      subject.templates(callback);
      var request = ajaxRequests[ajaxRequests.length-3];
      request.response({
        status: 200,
        responseText: JSON.stringify({templates: 'templates stuff'})
      });

      expect(callback).toHaveBeenCalledWith('templates stuff');
    });
  });

  describe('#local_images', function() {
    it('calls the supllied callback when the templates request resolves', function() {
      var callback = jasmine.createSpy('local images callback');
      subject.fetch('apache');
      subject.localImages(callback);
      var request = ajaxRequests[ajaxRequests.length-2];
      request.response({
        status: 200,
        responseText: JSON.stringify({local_images: 'local images stuff'})
      });

      expect(callback).toHaveBeenCalledWith('local images stuff');
    });
  });

  describe('#remote_images', function() {
    it('calls the supllied callback when the templates request resolves', function() {
      var callback = jasmine.createSpy('remote images callback');
      subject.fetch('apache');
      subject.remoteImages(callback);
      var request = mostRecentAjaxRequest();
      request.response({
        status: 200,
        responseText: JSON.stringify({remote_images: 'remote images stuff'})
      });

      expect(callback).toHaveBeenCalledWith('remote images stuff');
    });
  });
});

describe('$.PMX.TemplateDetailsDialog', function() {
  var modalContents,
      urlOption = 'http://localhost/templates/77/details',
      subject;

  beforeEach(function () {
    fixture.load('template-details-dialog.html');
    modalContents = $('#template-details-dialog');
    spyOn($.fn, "dialog");
    spyOn(window, "open");
    subject = new $.PMX.TemplateDetailsDialog('.template-details-link', {url: urlOption});
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
