(function($){
  $.PMX.JournalToggle = function(el, options){
    var base = this;

    base.$el = $(el);
    base.xhr = null;

    base.defaultOptions = {
      journalOutputSelector: '.journal-output',
      journalTruncatedHeight: '118px',
      journalFullHeight: '300px',
      trigger: 'a.journal-toggle'
    };

    base.init = function(){
      base.options = $.extend({}, base.defaultOptions, options);
      base.bindEvents();
    };

    base.bindEvents = function() {
      base.$el.on('click', base.options.trigger, base.handleToggle);
    };

    base.handleToggle = function(e) {
      e.preventDefault();
      base.toggleJournal();
    };

    base.toggleJournal = function() {
      var $journal = base.$el.find(base.options.journalOutputSelector);

      if ($journal.hasClass('truncated')) {

        $journal.animate({
          height: base.options.journalFullHeight
        }, {
          complete: function() {
            $journal.toggleClass('truncated');
            $journal.scrollTop($journal[0].scrollHeight);
            base.toggleLinkText();
          }
        });

      } else {

        $journal.animate({
          height: base.options.journalTruncatedHeight,
        }, {
          start: function() { $journal.toggleClass('truncated'); },
          progress: function() { $journal.scrollTop($journal[0].scrollHeight); },
          complete: function() { base.toggleLinkText(); }
        });

      }
    };

    base.toggleLinkText = function() {
      var $trigger = base.$el.find(base.options.trigger);
      var currentText = $trigger.text();
      var newText = $trigger.data('alt-text');

      $trigger.text(newText);
      $trigger.data('alt-text', currentText);
    };
  };

  $.fn.journalToggle = function(options){
    return this.each(function(){
      (new $.PMX.JournalToggle(this, options)).init();
    });
  };

})(jQuery);
