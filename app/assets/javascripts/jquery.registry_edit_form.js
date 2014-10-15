(function($){
  $.PMX.RegistryEditForm = function(form, options){
    var base = this;

    base.$form = form;

    base.defaultOptions = {};

    base.init = function(){
      base.options = $.extend({}, base.defaultOptions, options);
      base.bindEvents();
    };

    base.bindEvents = function() {
      base.$form.on('change', 'input[type="checkbox"]', base.handleCheck);
    };

    base.handleCheck = function(e) {
      base.submit();
    };

    base.submit = function() {
      return $.ajax({
        url: base.$form.attr('action'),
        headers: {
          Accept: 'application/json'
        },
        method: 'put',
        data: base.$form.serialize()
      });
    };
  };

  $.fn.registryEditForm = function(options){
    return this.each(function(){
      (new $.PMX.RegistryEditForm($(this), options)).init();
    });
  };

})(jQuery);
