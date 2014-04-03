describe('$.fn.filterableList', function() {
  beforeEach(function() {
    fixture.load('search.html');
    $('.filterable-list').filterableList();
    jasmine.Ajax.useMock();
  });

  describe('submitting the form', function() {
    it('prevents default behavior', function() {
      var submitEvent = $.Event('submit');
      $('.filterable-list form').trigger(submitEvent);
      expect(submitEvent.isDefaultPrevented()).toBeTruthy();
    });

    // shared examples here?
  });

  describe('changing the text in the query field', function() {
    it('requests results when the searchfield is changed', function() {
      $('input#search_query').val('mys').keyup();

      var request = mostRecentAjaxRequest();
      expect(request.url).toBe('/search.json?query=mys');
      expect(request.method).toBe('GET');
    });

    it('places the results on the page', function() {
      $('input#search_query').val('apache').keyup();

      var request = mostRecentAjaxRequest();

      var successResponseText = {
        q:"asd",
        remote_images:[
          {
            description:"some description",
            name:"some/name",
            id:"dlacewell/asdf"
          }
        ],
        local_images:[]
      }
      request.response({
        status: 200,
        responseText: JSON.stringify(successResponseText)
      });

      expect($('.search-results').html()).toContain('some/name');
      expect($('.search-results').html()).toContain('some description');
    });
  });
});
