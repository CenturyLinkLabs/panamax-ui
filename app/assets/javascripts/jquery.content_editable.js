(function($) {
  $.PMX.ContentEditable = function($el, options) {
    var base = this;

    base.$el = $el;

    base.defaultOptions = {
      confirmSelector: '.checkmark'
    };

    base.init = function(){
      base.options = $.extend({}, base.defaultOptions, options);
      base.prepareForEdit(base.$el);
    };

    base.textOnly = function($elem) {
      var node = $elem
        .contents()
        .filter(function() {
          return this.nodeType === 3; //Node.TEXT_NODE
        });
      return (node[0] !== undefined) ? node[0].data.replace(/[\n\r]/g, '').replace(/^\s+|\s+$/g,'') : ' ';
    };

    base.specialKey = function(code) {
      switch(code) {
        case 9: // KEY CODE FOR TAB
        case 13: // KEY CODE FOR ENTER
          return true;
        default:
          return false;
      }
    };

    base.prepareForEdit = function($content) {
      var checkmark = '<div class="checkmark" contenteditable="false" data-identifier="' + base.options.identifier +'"></div>',
          data = base.textOnly($content),
          editable = '<span class="edit-field" contenteditable="true">' + data + '</span>';

      $content.attr('data-original', base.textOnly($content))
              .addClass('content-editable')
              .attr('data-identifier', base.options.identifier);
      $content.empty();
      $(editable).appendTo($content);
      $(checkmark).appendTo($content);
      base.selectionRange($content);
      base.bindEvents($content);
    };

    base.selectionRange = function($content) {
      var edit = $content.find('.edit-field'),
          range = document.createRange(),
          sel   = window.getSelection(),
          t = edit[0];

      range.setStartBefore(t);
      range.collapse(true);
      sel.removeAllRanges();
      sel.addRange(range);
      edit.focus();
    };

    base.bindEvents = function($content) {
      $content.unbind('keydown').on('keydown', base.handleContent)
              .unbind('keyup').on('keyup',base.dirtyCheck)
              .find(base.options.confirmSelector).unbind('click').on('click', base.handleCheckmark );
    };

    base.revert = function($content) {
      var $child = ($content.find('.checkmark').length !== 0) ? $content.find('.checkmark') : $content.find('.loading'),
          data = base.textOnly($content.find('.edit-field')),
          identifier =  $child.attr('data-identifier');

      $content.attr('contenteditable', 'false')
              .css('outline', 'none')
              .unbind('keydown')
              .removeClass('content-editable')
              .empty()
              .text(data);

      if (base.options.onRevert) { base.options.onRevert(identifier); }
    };

    base.commitChange = function(to) {
      var $child = (to.find('.checkmark').length !== 0) ? to.find('.checkmark') : to.find('.loading'),
          identifier =  $child.attr('data-identifier'),
          data = to.find('.edit-field'),
          editor = base.options.editorPromise({text: base.textOnly(data), id: identifier, original: to.attr('data-original')});

      to.find('.checkmark')
        .addClass('loading')
        .removeClass('checkmark');

      editor.then(function() {
        base.revert(to);
      }, function() {
        base.revert(to);
      });
    };

    base.dirtyCheck = function(e) {
      var $content = $(e.currentTarget),
        contentText = base.textOnly($content.find('.edit-field')),
        $parent = $content.closest(base.$el),
        original = $parent.attr('data-original');

      if (contentText !== original) {
        $parent.find(base.options.confirmSelector).addClass('dirty');
      } else {
        $parent.find(base.options.confirmSelector).removeClass('dirty');
      }
    };

    base.handleContent = function(e) {
      var $content = $(e.currentTarget),
          $parent = $content.closest(base.$el),
          keyCode = e.which || e.keyCode;

      base.dirtyCheck(e);
      if (base.specialKey(keyCode)) {
        e.preventDefault();
        if ($parent.find(base.options.confirmSelector).hasClass('dirty')) {
          base.commitChange($content);
        } else {
          base.revert($content);
        }
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

      if ($target.hasClass('dirty')) {
        base.commitChange($content);
      } else {
        base.revert($content);
      }
    };
  };

  $.fn.contentEditable = function(options){
  return this.each(function(){
    (new $.PMX.ContentEditable($(this), options)).init();
  });
};

})(jQuery);
