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

  $('main').noticeActions();

  $('.instructions-dialog').appInstructionsDialog();

  $('.service-edit-form').progressiveForm();

  var $environmentVarAdditionalEntries = $('.environment-variables .additional-entries');
  $environmentVarAdditionalEntries.appendable({
    $trigger: $('.environment-variables .button-add'),
    $elementToAppend: $environmentVarAdditionalEntries.find('dl:first-of-type'),
    addCallback: function(addedItem) {
      addedItem.$el.find('input').each(function() {
        var $el = $(this);
        var name = $el.attr('name');
        var newName = name.replace('_replaceme_', (new Date).getTime());
        $el.attr('name', newName);
      });
    }
  });

  var $portAdditionalEntries = $('.port-detail .additional-entries');
  $portAdditionalEntries.appendable({
    $trigger: $('.port-detail .button-add'),
    $elementToAppend: $portAdditionalEntries.find('li:first-of-type'),
    addCallback: function(addedItem) {
      addedItem.$el.find('input').each(function() {
        var $el = $(this);
        $el.prop('disabled', false);
        var name = $el.attr('name');
        var newName = name.replace('_replaceme_', (new Date).getTime());
        $el.attr('name', newName);
      });
    }
  });

  $('.service-links').appendableServiceLinks();

};

