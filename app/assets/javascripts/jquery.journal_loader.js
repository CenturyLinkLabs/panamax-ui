(function($){
  $.PMX.JournalLoader = function(el, options){
    var base = this;

    base.$el = $(el);
    base.xhr = null;
    base.timer = null;
    base.cursor = '';

    base.defaultOptions = {
      refreshInterval: 1000,
      journalLineTemplate: Handlebars.compile($('#journal_line_template').html()),
    };

    base.init = function(){
      base.options = $.extend({}, base.defaultOptions, options);
      base.fetchJournal();
    };

    base.fetchJournal = function() {
      if (base.xhr) {
        base.xhr.abort();
      }

      base.xhr = $.ajax({
        url: base.journalEndpoint()
      });

      base.xhr.done(function(response, status) {
        base.updateJournal(response);
        clearTimeout(base.timer);
        base.timer = setTimeout(base.fetchJournal, base.options.refreshInterval);
      });
    };

    base.journalEndpoint = function() {
      return base.$el.data('source')
        + '?cursor='
        + encodeURIComponent(base.cursor);
    };

    base.updateJournal = function(journal_lines) {
      var journalText = '';

      $.each(journal_lines, function(i, journal_line) {
        // Skip line if current cursor matches saved cursor (dupe)
        if (journal_line['__CURSOR'] != base.cursor) {
          journalText += base.formatJournalLine(journal_line);
          base.cursor = journal_line['__CURSOR'];
        }
      });

      if (journalText.length) {
        var scrolledToBottom = base.scrolledToBottom();

        base.$el.append(journalText);

        if (scrolledToBottom) {
          base.$el.animate({ scrollTop: base.$el[0].scrollHeight });
        }
      }
    };

    base.formatJournalLine = function(journal_line) {
      var attrs = {
        timestamp: base.formatTimestamp(journal_line['__REALTIME_TIMESTAMP']),
        source: journal_line['SYSLOG_IDENTIFIER'],
        message: journal_line['MESSAGE']
      };

      return base.options.journalLineTemplate(attrs);
    };

    base.formatTimestamp = function(timestamp) {
      seconds = Math.floor(parseInt(timestamp) / 1000);
      return moment(seconds).format("MMM DD HH:mm:ss");
    };

    base.scrolledToBottom = function() {
      var div = base.$el[0];
      return (div.scrollHeight - div.clientHeight) <= (div.scrollTop + 1);
    };
  };

  $.fn.journalLoader = function(options){
    return this.each(function(){
      (new $.PMX.JournalLoader(this, options)).init();
    });
  };

})(jQuery);
