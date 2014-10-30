(function($) {
  $(document).ready(function() {
    $.PMX.init();
  });

  $.PMX.init = function() {

    $('body').analyticsClickTracker();

    $(document).errorInterceptor();

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

    $('aside.metrics').hostHealth();

    $('.service-details .state span.metrics').serviceHealth();

    $('.service-help-icon').contextHelp();

    $('.application-access').contextHelp({'top': '16px'});

    $('#template_flow button.preview').previewTemplate();

    $('#template_flow a#token-replace').replaceToken();

    $('#images_flow section.image').imageActions();

    $('header.application h1 li:last-of-type').editApplicationName();

    var enableNewItem = function(addedItem) {
      var uid = $.PMX.Helpers.guid();
      addedItem.$el.find('input').each(function() {
        $(this).prop('disabled', false);
        var name = $(this).attr('name');
        var newName = name.replace('_replaceme_', uid);
        $(this).attr('name', newName);
      });
    };

    $('.service-details').dockerRun();

    $('.environment-variables .additional-entries').appendable({
      $trigger: $('.environment-variables .button-add'),
      $elementToAppend: $('.environment-variables .additional-entries dl:first-of-type'),
      addCallback: enableNewItem
    });

    $('.volumes .data-containers .additional-entries').appendable({
      $trigger: $('.volumes .data-containers .button-add'),
      $elementToAppend: $('.volumes .data-containers .additional-entries li:first-of-type'),
      addCallback: enableNewItem
    });

    $('.template-repos').templateRepoActions();

    $('.registries').registriesActions();

    $('.exposed-ports').appendableExposePorts();

    $('.service-links').appendableServiceLinks();

    $('.port-bindings').appendablePortBindings();

    $('.mounted-containers').appendableVolumesFrom();

    $('.environment-variables dl.entries').editParameter({
      fieldSelector: 'dt.variable-name label',
      inputKey: 'input[data-index=name_%]'
    });

    $('.environment-variables dl.entries').editParameter({
      fieldSelector: 'dd.variable-value span',
      editSelector: 'dd.variable-value a.edit-action',
      inputKey: 'input[data-index=value_%]'
    });
    $('.journal-output').journalLoader();

    $('.journal-toggle').journalToggle();

    $('.blog-feed-items').rssReader();

    $('.service-status').serviceStatus();

    $('.service-details .inspect').dockerInspect();

    $('.application-services').appServicesStatus();

    $('table.port-bindings tbody tr').portMappings();

    $('[data-accordian-expand]').accordian();

    $('[data-toggle-class]').toggleTargetClass();

    $('form.edit-registry').registryEditForm();

    $('.tab-container').fingerTabs();

    $('[data-delete-confirm]').confirmAndDelete();

    $('body').selectDeploymentTarget();
  };
})(jQuery);
