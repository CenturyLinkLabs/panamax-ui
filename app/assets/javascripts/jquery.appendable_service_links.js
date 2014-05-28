(function($){
  $.PMX.AppendableServiceLinks = function($el){
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
      addedItem.$el.find('select, input').each(function() {
        base.makeNameUnique($(this));
        $(this).prop('disabled', false);
      });

      addedItem.$el.find('select').each(function() {
        base.updateHiddenFields($(this));
        $(this).on('change', function(e) {
          base.updateHiddenFields($(e.currentTarget));
        });
        $(this).chosen({disable_search: true});
      });
    };

    base.updateHiddenFields = function($select) {
      var $associated = $select.siblings('[name*="alias"]');
      var text = $select.find('option:selected').text();
      $associated.val(text);
    };

    base.makeNameUnique = function($input) {
      var name = $input.attr('name');
      var newName = name.replace('_replaceme_', (new Date()).getTime());
      $input.attr('name', newName);
    };

  };

  $.fn.appendableServiceLinks = function(options){
    return this.each(function(){
      (new $.PMX.AppendableServiceLinks($(this))).init();
    });
  };

})(jQuery);
