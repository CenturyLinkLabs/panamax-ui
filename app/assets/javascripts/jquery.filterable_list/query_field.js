(function($){

  $.PMX.QueryField = function(el) {
    var base = this;

    base.$el = $(el);
    base.previousTerm = '';
    base.timer = null;

    base.bindEvents = function() {
      base.$el.on('keyup', base.handleChange);
    };

    base.handleChange = function() {
      if (base.isDifferent()) {
        clearTimeout(base.timer);
        base.timer = setTimeout(base.recordChange, 250);
      }
    };

    base.recordChange = function() {
      base.changeCallback.call(base, base.getTerm());
      base.previousTerm = base.getTerm();
    };

    base.onChange = function(callback) {
      base.changeCallback = callback;
    };

    base.isDifferent = function() {
      return (base.getTerm().length > 2 && base.getTerm() !== base.previousTerm);
    };

    base.getTerm = function() {
      return base.$el.val();
    };
  };

})(jQuery);
