(function($){
  $.PMX.RssReader = function($el, options) {
    var base = this;

    base.$el = $el;
    base.xhr = null;

    base.defaultOptions = {
      proxyUrl: 'http://ajax.googleapis.com/ajax/services/feed/load',
      itemCount: 5,
      blogItemTemplate: Handlebars.compile($('#blog_item_template').html()),
    };

    base.init = function() {
      base.options = $.extend({}, base.defaultOptions, options);
      base.retrieveFeed();
    };

    base.retrieveFeed = function() {
      if (base.xhr) {
        base.xhr.abort();
      }

      base.xhr = $.ajax({
        url: base.options.proxyUrl,
        data: { v: '1.0', num: base.options.itemCount, q: base.$el.data('source') },
        dataType: 'jsonp',
        success: function(data) {
          base.renderFeed(data.responseData.feed);
        }
      });
    };

    base.renderFeed = function(feed) {
      var feedText = '';

      $.each(feed.entries, function(i, entry) {
        feedText += base.formatBlogItem(entry);
      });

      base.$el.append(feedText);
    };

    base.formatBlogItem = function(item) {
      var attrs = {
        timestamp: base.formatTimestamp(item.publishedDate),
        title: item.title,
        link: item.link
      };

      return base.options.blogItemTemplate(attrs);
    };

    base.formatTimestamp = function(timestamp) {
      return moment(new Date(timestamp)).format('MMMM D, YYYY');
    };
  };

  $.fn.rssReader = function(options){
    return this.each(function() {
      (new $.PMX.RssReader($(this), options)).init();
    });
  };

})(jQuery);
