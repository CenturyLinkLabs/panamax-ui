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

    describe('when the tags are not yet loaded', function() {
      it('places the tags in the select', function() {
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

      it('sends the local_image and registry_id in the request', function() {
        $('input.query-field').val('apache').keyup();

        $('.remote-image-results .chosen-container').first().click();

        request = mostRecentAjaxRequest();
        request.response({
          status: 200,
          responseText: JSON.stringify(['foo', 'bar'])
        });

        var urlFragments = request.url.split(/[\?\&]/);
        expect(urlFragments).toContain('local_image=false');
        expect(urlFragments).toContain('registry_id=321');
      });
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
        expect(args[1]['url']).toMatch("/templates/77/details")
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
