(function($) {
  $.PMX.AppendableVolumesFrom = function($el, options) {
    var base = this;

    base.$el = $el;
    base.defaultOptions = {

    };

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
      addedItem.$el.find('select, input').each(function() {
        base.substituteName($(this), guid);
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
      var $associated = $select.siblings('[name*="mount"]');
      var text = $select.find('option:selected').text();
      $associated.val(text);
    };

    base.substituteName = function($input, guid) {
      var name = $input.attr('name');
      var newName = name.replace('_replaceme_', guid);
      $input.attr('name', newName);
    };
  };

  $.fn.appendableVolumesFrom = function(options) {
    return this.each(function() {
      (new $.PMX.AppendableVolumesFrom($(this), options)).init();
    });
  };
})(jQuery);
