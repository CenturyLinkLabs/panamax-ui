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
      expect(request.url).toBe('/search.json?query=mys');
      expect(request.method).toBe('GET');
    });
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
        remote_images: [
          {
            description:"some description",
            name:"some/name",
            id:"dlacewell/asdf"
          }
        ],
        local_images: [
          {
            description:"a local image",
            name:"local/image",
            id:"dlacewell/local"
          }
        ],
        templates: [
          {
            name: 'some template',
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
