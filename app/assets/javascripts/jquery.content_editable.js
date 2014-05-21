(function($) {
  $.PMX.ContentEditable = function(el, options) {
    var base = this,
        textOnly = function($elem) {
          return $elem
                  .contents()
                  .filter(function() {
                    return this.nodeType === 3; //Node.TEXT_NODE
                  })[0].data.replace(/[\n\r]/g, '').replace(/ /g,'');
        },
        specialKey = function(code) {
          switch(code) {
            case 9:
            case 13:
              return true;
            default:
              return false;
          }
        };


    base.$el = $(el);
    base.originalContent = null;
    base.$editElement = null;

    base.defaultOptions = {
       confirmSelector: '.checkmark',
       editSelector: 'a.edit-action'
    };

    base.init = function(){
      base.options = $.extend({}, base.defaultOptions, options);
      base.bindEvents();
    };

    base.bindEvents = function() {
      $(base.$el).unbind('click').on('click', base.options.editSelector, base.handleTrigger);
    };

    base.prepareForEdit = function($content) {
      base.$el.attr('data-original', textOnly($content));
      $('<div class="checkmark" contenteditable="false"></div>').appendTo($content);
      $content.addClass('content-editable');
      $content.attr('contenteditable', 'true');
      $content.unbind('keydown').on('keydown', base.handleContent);
      $content.unbind('keyup').on('keyup', base.dirtyCheck);
      $content.find(base.options.confirmSelector).unbind('click').on('click', base.handleCheckmark )
    };

    base.revert = function($content) {
      $content.attr('contenteditable', 'false');
      $content.css('outline', 'none');
      $content.unbind('keydown');
      $content.find('.checkmark').remove();
      $content.find(base.options.editSelector).css('display', 'block');
      $content.removeClass('content-editable');
    };

    base.commitChange = function(to) {
      var editor = base.options.editorPromise(base.options.editorPromise(textOnly(to)));

      editor.then(function() {
        base.revert(to);
      }, function() {
        base.revert(to);
        debugger;
        to.contents()
          .filter(function() {
            return this.nodeType === 3; //Node.TEXT_NODE
          })[0].data = to.attr('data-original');
      });
    };

    base.dirtyCheck = function(e) {
      var $content = $(e.currentTarget),
        contentText = textOnly($content),
        $parent = $content.closest(base.$el);

      (contentText !== base.originalContent) ? $parent.find(base.options.confirmSelector).addClass('dirty')
                                             : $parent.find(base.options.confirmSelector).removeClass('dirty');

    };

    base.handleContent = function(e) {
      var $content = $(e.currentTarget),
          $parent = $content.closest(base.$el),
          keyCode = e.which || e.keyCode;

      if (specialKey(keyCode)) {
        e.preventDefault();
        ($parent.find(base.options.confirmSelector).hasClass('dirty')) ? base.commitChange($content)
                                                                       : base.revert($content);
      } else {
        base.dirtyCheck(e);
      }

    };

    base.handleTrigger = function(e) {
      var $target = $(e.currentTarget);

      e.preventDefault();
      $target.css('display', 'none');
      base.prepareForEdit($target.closest(base.$el));
    };

    base.handleCheckmark = function(e) {
      var $target = $(e.currentTarget),
          $content = $target.closest(base.$el);

      ($target.hasClass('dirty')) ? base.commitChange($content) : base.revert($content);
    }
  };

  $.fn.contentEditable = function(options){
  return this.each(function(){
    (new $.PMX.ContentEditable($(this), options)).init();
  });
};

})(jQuery);
