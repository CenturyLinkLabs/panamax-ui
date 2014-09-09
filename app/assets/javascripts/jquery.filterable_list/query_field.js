(function($){

  $.PMX.QueryField = function(el) {
    var base = this;

    base.$el = $(el);
    base.previousTerm = '';

    base.bindEvents = function() {
      base.$el.on('keyup', base.handleChange);
    };

    base.handleChange = function() {
      if (base.getTerm().length > 2 && base.getTerm() !== base.previousTerm) {
        base.changeCallback.call(base, base.getTerm());
        base.previousTerm = base.getTerm();
      }
    };

    base.onChange = function(callback) {
      base.changeCallback = callback;
    };

    base.getTerm = function() {
      return base.$el.val();
    };
  };

})(jQuery);
