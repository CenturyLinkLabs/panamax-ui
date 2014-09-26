(function($) {
  $.PMX.EditParameter = function($el, options) {
    var base = this;

    base.$el = $el;
    base.xhr = null;

    base.defaultOptions = {
      fieldSelector: 'dt.variable-name label',
      editSelector: 'dt.variable-name a.edit-action',
      formSelector: 'dd.actions',
      inputKey: 'input[data-index=name_%]',
      submitButton: '.service-details form input[type=submit]'
    };

    base.init = function () {
      base.options = $.extend({}, base.defaultOptions, options);
      base.bindEvents();
    };

    base.bindEvents = function () {
      base.$el.on('click', base.options.editSelector, base.handleEdit);
    };

    base.handleEdit = function(e) {
      var $target = $(e.currentTarget),
          $parent = $target.parent();

      e.preventDefault();
      $parent.css('display', 'none');

      (new $.PMX.ContentEditable(base.$el.find(base.options.fieldSelector),
        {
          identifier: $parent.val(),
          onRevert: base.handleRevert,
          editorPromise: base.completeEdit
        })).init();
    };

    base.handleRevert = function(e) {
      (base.$el.find(base.options.editSelector).parent())[0].style.cssText = '';
    };

    base.completeEdit = function(data) {
      var transaction = $.Deferred(),
          index = base.$el.find(base.options.fieldSelector).attr('data-index'),
          field = base.$el.find(base.options.formSelector).find(base.options.inputKey.replace('%', index)).first();

      field.val(data.text);
      $(base.options.submitButton).removeAttr('disabled');
      $('body').trigger('progressiveForm:changed');
      transaction.resolve();

      return transaction.promise();
    };

  };

  $.fn.editParameter = function(options){
    return this.each(function(){
      (new $.PMX.EditParameter($(this), options)).init();
    });
  };

})(jQuery);
