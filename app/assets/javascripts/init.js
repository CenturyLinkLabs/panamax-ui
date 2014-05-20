$(document).ready(function() {
  $.PMX.init();
});

$.PMX.init = function() {

  $('body').analyticsClickTracker();

  $('.example-searches').searchQueryPopulator({
    $searchField: $('input#search_form_query')
  });

  $('#search_flow .filterable-list').filterableList({
    trackingAction: 'create'
  });

  $('#add-service-form .filterable-list').filterableList({
    trackingAction: 'add'
  });

  $('ul.services li').serviceActions();
  $('section.application-services').serviceViews();

  $('section.applications').applicationActions();

  $('.category-panel').categoryActions();

  $('.service-edit-form').progressiveForm();

  var $environmentVarAdditionalEntries = $('.environment-variables .additional-entries');
  $environmentVarAdditionalEntries.appendable({
    $trigger: $('.environment-variables .button-add'),
    $elementToAppend: $environmentVarAdditionalEntries.find('dl:first-of-type'),
    addCallback: function(addedItem) {
      addedItem.$el.find('input').each(function() {
        var name = $(this).attr('name');
        var newName = name.replace('_replaceme_', (new Date).getTime());
        $(this).attr('name', newName);
      });
    }
  });

  var $portAdditionalEntries = $('.port-detail .additional-entries');
  $portAdditionalEntries.appendable({
    $trigger: $('.port-detail .button-add'),
    $elementToAppend: $portAdditionalEntries.find('li:first-of-type'),
    addCallback: function(addedItem) {
      addedItem.$el.find('input').each(function() {
        $(this).prop('disabled', false);
        var name = $(this).attr('name');
        var newName = name.replace('_replaceme_', (new Date).getTime());
        $(this).attr('name', newName);
      });
    }
  });

  $('.journal-output').journalLoader();

  $('.journal-toggle').journalToggle();
};
