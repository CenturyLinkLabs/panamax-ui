(function($){

  $.PMX.SearchResults = function(url, limit) {
    var base = this;

    base.url = url;
    base.limit = limit;
    base.templatesXhr = null;
    base.localImagesXhr = null;
    base.remoteImagesXhr = null;

    base.fetch = function(term) {
      if (base.templatesXhr) { base.templatesXhr.abort(); }
      if (base.localImagesXhr) { base.localImagesXhr.abort(); }
      if (base.remoteImagesXhr) { base.remoteImagesXhr.abort(); }

      base.templatesXhr = base.fetchForType(term, 'template');
      base.localImagesXhr = base.fetchForType(term, 'local_image');
      base.remoteImagesXhr = base.fetchForType(term, 'remote_image');
    };

    base.templates = function(callback) {
      base.templatesXhr.done(function(response, status) {
        callback.call(this, response.templates);
      });
    };

    base.localImages = function(callback) {
      base.localImagesXhr.done(function(response, status) {
        callback.call(this, response.local_images);
      });
    };

    base.remoteImages = function(callback) {
      base.remoteImagesXhr.done(function(response, status) {
        callback.call(this, response.remote_images);
      });
    };

    base.fetchForType = function(term, type) {
      return $.ajax({
        url: base.url,
        data: {
          'search_result_set[q]': term,
          'search_result_set[type]': type,
          'search_result_set[limit]': base.limit
        }
      });
    };
  };
})(jQuery);
