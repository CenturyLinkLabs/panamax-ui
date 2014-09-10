(function($){
  $.PMX.AppendableExposePorts = function($el){
    var base = this;

    base.$el = $el;

    base.init = function() {
      var $linksAdditionalEntries = base.$el.find('.additional-entries');
      $linksAdditionalEntries.appendable({
        $trigger: base.$el.find('.button-add'),
        $elementToAppend: $linksAdditionalEntries.find('li:first-of-type'),
        addCallback: base.handleAppend
      });

    };

    base.handleAppend = function(addedItem) {
      var guid = $.PMX.Helpers.guid();
      addedItem.$el.find('input').each(function() {
        base.substituteName($(this), guid);
        $(this).prop('disabled', false);
      });
    };

    base.updateHiddenFields = function($select) {
      var $associated = $select.siblings('[name*="alias"]');
      var text = $select.find('option:selected').text();
      $associated.val(text);
    };

    base.substituteName = function($input, guid) {
      var name = $input.attr('name');
      var newName = name.replace('_replaceme_', guid);
      $input.attr('name', newName);
    };

  };

  $.fn.appendableExposePorts = function(options){
    return this.each(function(){
      (new $.PMX.AppendableExposePorts($(this))).init();
    });
  };

})(jQuery);
