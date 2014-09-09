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

