describe('$.fn.filterableList', function() {
  beforeEach(function() {
    fixture.load('search.html');
    $('.filterable-list').filterableList();
    jasmine.Ajax.useMock();
  });

  describe('submitting the form', function() {
    it('displays the loading indicator', function() {
      expect($('.in-progress').length).toEqual(0);
      $('input#search_query').val('mys');
      $('.filterable-list form').submit();
      expect($('.in-progress').length).toEqual(2);
    });

    it('prevents default behavior', function() {
      var submitEvent = $.Event('submit');
      $('.filterable-list form').trigger(submitEvent);
      expect(submitEvent.isDefaultPrevented()).toBeTruthy();
    });

    it('requests results', function() {
      $('input#search_query').val('mys');
      $('.filterable-list form').submit();

      var request = mostRecentAjaxRequest();
      expect(request.url).toBe('/search.json?search_form%5Bquery%5D=mys');
      expect(request.method).toBe('GET');
    });

    it('displays the search headings', function() {
      $('h3.search-title').hide();
      $('.filterable-list form').submit();
      expect($('h3.search-title:visible').length).toEqual(2);
    });
  });

  describe('changing the text in the query field', function() {
    it('does not request results if fewer than 3 characters exist', function() {
      $('input#search_query').val('my').keyup();

      var request = mostRecentAjaxRequest();
      expect(request.url).not.toBe('/search.json?search_form%5Bquery%5D=my');
    });

    it('does not re-request results if the value has not actually changed', function() {
      $('input#search_query').val('word').keyup();
      $('input#search_query').val('word').keyup();

      var request = mostRecentAjaxRequest();
      var secondToLastAjaxRequest = ajaxRequests[ajaxRequests.length - 2]
      expect(request.url).toBe('/search.json?search_form%5Bquery%5D=word');
      expect(secondToLastAjaxRequest.url).not.toBe('/search.json?search_form%5Bquery%5D=word');
    });

    it('aborts the previous xhr request when sending a new one', function() {
      fakeXhr = {
        abort: function() {},
        done: function() {return fakeXhr;}
      }
      spyOn($, 'ajax').andReturn(fakeXhr)
      spyOn(fakeXhr, 'abort');

      $('input#search_query').val('word').keyup();
      $('input#search_query').val('apac').keyup();

      expect(fakeXhr.abort.calls.length).toEqual(1);
    });

    it('requests results when the searchfield is changed', function() {
      $('input#search_query').val('mys').keyup();

      var request = mostRecentAjaxRequest();
      expect(request.url).toBe('/search.json?search_form%5Bquery%5D=mys');
      expect(request.method).toBe('GET');
    });

    it('places the results on the page', function() {
      $('input#search_query').val('apache').keyup();

      var request = mostRecentAjaxRequest();

      var successResponseText = {
        q:"asd",
        remote_images: [
          {
            description:"some description",
            title:"some/name",
            id:"dlacewell/asdf"
          }
        ],
        local_images: [
          {
            description:"a local image",
            title:"local/image",
            id:"dlacewell/local"
          }
        ],
        templates: [
          {
            title: 'some template',
            description: 'this template will change your life'
          }
        ]
      };

      request.response({
        status: 200,
        responseText: JSON.stringify(successResponseText)
      });

      expect($('.image-results').html()).toContain('some/name');
      expect($('.image-results').html()).toContain('some description');
      expect($('.image-results').html()).toContain('local/image');
      expect($('.image-results').html()).toContain('a local image');
      expect($('.template-results').html()).toContain('some template')
      expect($('.template-results').html()).toContain('this template will change your life')
    });

    it('says sorry if it cannot find a template', function() {
      $('input#search_query').val('apache').keyup();

      var request = mostRecentAjaxRequest();

      var successResponseText = {
        q:"asd",
        remote_images: [],
        local_images: [],
        templates: []
      };

      request.response({
        status: 200,
        responseText: JSON.stringify(successResponseText)
      });

      expect($('.template-results').html()).toContain('sorry, nothin here');
    });
  });
});
