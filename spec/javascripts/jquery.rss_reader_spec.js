describe('$.fn.rssReader', function() {
  var subject,
      $blogFeed;

  var rssResponse = {
    responseData: {
      feed: {
        entries: [
          {
            publishedDate: 'Wed, 18 Jun 2014 13:18:10 -0700',
            title: 'Foo',
            link: 'http://foo.com/bar'
          }
        ]
      }
    }
  };

  beforeEach(function() {
    fixture.load('blog-feed.html');
    $blogFeed = $('#teaspoon-fixtures').find('.blog-feed-items');
    subject = new $.PMX.RssReader($blogFeed);

    spyOn($, 'ajax').andCallFake(function(options) {
      options.success(rssResponse);
    });
  });

  describe('init', function() {

    it('queries the feed with the correct parameters', function() {
      subject.init();

      var ajax = $.ajax.mostRecentCall.args[0];
      expect(ajax.url).toEqual(subject.defaultOptions.proxyUrl);
      expect(ajax.dataType).toEqual('jsonp');
      expect(ajax.data.v).toEqual('1.0');
      expect(ajax.data.num).toEqual(5);
      expect(ajax.data.q).toEqual($blogFeed.data('source'));
    });

    it('displays the formatted blog feed', function() {
      subject.init();

      var feedItems = rssResponse.responseData.feed.entries;
      expect($blogFeed.text()).toContain(feedItems[0].title);
      expect($blogFeed.html()).toContain(feedItems[0].link);

      var date = moment(new Date(feedItems[0].publishedDate));
      expect($blogFeed.text()).toContain(date.format('MMMM D, YYYY'));
    });

    describe('when a request is already in-progress', function() {

      var fakeAjax = {
        abort: function() {},
        done: function() { return fakeAjax; }
      };

      beforeEach(function() {
        subject.xhr = fakeAjax;
        spyOn(fakeAjax, 'abort');
      });

      it('aborts previous requests', function() {
        subject.init();
        expect(fakeAjax.abort.calls.length).toEqual(1);
      });
    });
  });
});
