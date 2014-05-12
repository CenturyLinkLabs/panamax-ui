$(document).ready(function() {
  $.PMX.init();
});

$.PMX.init = function() {

  $('.example-searches').searchQueryPopulator({
    $searchField: $('input#search_form_query')
  });

  $('.filterable-list').filterableList({
    $queryField: $('input#search_form_query')
  });

  $('ul.services li').serviceActions();

  $('.category-panel').categoryActions();

  $('.service-edit-form').progressiveForm();

  var $environmentVarAdditionalEntries = $('.environment-variables .additional-entries')
  $environmentVarAdditionalEntries.appendable({
    $elementToAppend: $environmentVarAdditionalEntries.find('dl:first-of-type'),
    addCallback: function(addedItem) {
      addedItem.$el.find('input').each(function() {
        var name = $(this).attr('name');
        var newName = name.replace('_replaceme_', (new Date).getTime());
        $(this).attr('name', newName);
      });
    }
  });
};
