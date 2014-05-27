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

    base.defaultOptions = {
       confirmSelector: '.checkmark'
    };

    base.prepareForEdit = function($content) {
      var checkmark = '<div class="checkmark" contenteditable="false" data-identifier="' + base.options.identifier +'"></div>';

      $(checkmark).appendTo($content);
      $content.attr('data-original', textOnly($content))
              .addClass('content-editable')
              .attr('data-identifier', base.options.identifier)
              .attr('contenteditable', 'true');
      base.bindEvents($content);
    };

    base.bindEvents = function($content) {
      $content.unbind('keydown').on('keydown', base.handleContent)
              .unbind('keyup').on('keyup', base.dirtyCheck)
              .find(base.options.confirmSelector).unbind('click').on('click', base.handleCheckmark );
    };

    base.revert = function($content) {
      var $child = ($content.find('.checkmark').length !== 0) ? $content.find('.checkmark') : $content.find('.loading'),
          identifier =  $child.attr('data-identifier');

      $content.attr('contenteditable', 'false')
              .css('outline', 'none')
              .unbind('keydown')
              .removeClass('content-editable')
              .find(base.options.editSelector).css('display', 'block');

      $child.remove();
      if (base.options.onRevert) base.options.onRevert(identifier);
    };

    base.commitChange = function(to) {
      var editor = base.options.editorPromise(base.options.editorPromise(textOnly(to)));

      to.find('.checkmark')
        .addClass('loading')
        .removeClass('checkmark');

      editor.then(function() {
        base.revert(to);
      }, function() {
        base.revert(to);
        to.contents()
          .filter(function() {
            return this.nodeType === 3; //Node.TEXT_NODE
          })[0].data = to.attr('data-original');
      });
    };

    base.dirtyCheck = function(e) {
      var $content = $(e.currentTarget),
        contentText = textOnly($content),
        original = $content.attr('data-original');
        $parent = $content.closest(base.$el);

      (contentText !== original) ? $parent.find(base.options.confirmSelector).addClass('dirty')
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
    };

    base.init = function(){
      base.options = $.extend({}, base.defaultOptions, options);
      base.prepareForEdit(base.$el);
    };
  };

  $.fn.contentEditable = function(options){
  return this.each(function(){
    (new $.PMX.ContentEditable($(this), options)).init();
  });
};

})(jQuery);
