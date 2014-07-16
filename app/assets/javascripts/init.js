(function($) {
  $(document).ready(function() {
    $.PMX.init();
  });

  $.PMX.init = function() {

    $('body').analyticsClickTracker();

    $('select.fancy').chosen({disable_search: true});

    $('.example-searches').searchQueryPopulator({
      $searchField: $('input.query-field')
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

    $('aside.host').hostHealth();

    $('header.application h1 li:last-of-type').editApplicationName();

    var enableNewItem = function(addedItem) {
      addedItem.$el.find('input').each(function() {
        $(this).prop('disabled', false);
        var name = $(this).attr('name');
        var newName = name.replace('_replaceme_', (new Date()).getTime());
        $(this).attr('name', newName);
      });
    };

    $('.environment-variables .additional-entries').appendable({
      $trigger: $('.environment-variables .button-add'),
      $elementToAppend: $('.environment-variables .additional-entries dl:first-of-type'),
      addCallback: enableNewItem
    });

    $('.exposed-ports').appendableExposePorts();

    $('.service-links').appendableServiceLinks();

    $('.port-bindings').appendablePortBindings();

    $('.journal-output').journalLoader();

    $('.journal-toggle').journalToggle();

    $('.blog-feed-items').rssReader();

    $('.service-status').serviceStatus();

    $('.application-services').appServicesStatus();

  };
})(jQuery);
