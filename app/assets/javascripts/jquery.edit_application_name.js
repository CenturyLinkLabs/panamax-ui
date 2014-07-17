(function($){
  $.PMX.EditApplicationName = function(el, options) {
    var base = this;

    base.$el = $(el);
    base.defaultOptions = {
      content: 'span.application-title',
      editSelector: '.actions a.edit-action'
    };

    base.init = function() {
      base.options = $.extend({}, base.defaultOptions, options);
      base.wrapTitle();
      base.bindEvents();

    };

    base.wrapTitle = function() {
      var wrapper = "<span class='application-title'>_REPLACE_</span><div class='actions'>" +
          "<a class='edit-action' href='#'></a></div>",
          title = base.$el.html();

      base.$el.html(wrapper.replace('_REPLACE_', title));
    };

    base.bindEvents = function() {
      base.$el.find(base.options.editSelector).on('click', base.handleEdit);
    };

    base.handleEdit = function(e) {
      var $target = $(e.currentTarget),
        $parent = $target.parent();

      e.preventDefault();
      $parent.css('display', 'none');
      base.editableName = (new $.PMX.ContentEditable(base.$el.find(base.options.content),
        {
          identifier: $parent.val(),
          onRevert: base.handleRevert,
          editorPromise: base.completeEdit
        })).init();
    };

    base.handleRevert = function() {
      base.$el.find('.actions')[0].style.cssText = '';
    };

    base.completeEdit = function(data) {
      return $.ajax({
        type: 'PUT',
        headers: {
          'Accept': 'application/json'
        },
        url: window.location.pathname,
        data: {
          app: {
            name: data.text
          }
        }
      }).success(function() {
        // jQuery setting inline style this is better cross browser way to remove that //
        base.$el.find('.actions')[0].style.cssText = '';
      });
    };
  };

  $.fn.editApplicationName = function(){
    return this.each(function(){
      (new $.PMX.EditApplicationName($(this))).init();
    });
  };
})(jQuery);
