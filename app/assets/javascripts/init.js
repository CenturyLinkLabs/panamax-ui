(function($) {
  $(document).ready(function() {
    $.PMX.init();
  });

  $.PMX.init = function() {

    $('body').analyticsClickTracker();

    $(document).errorInterceptor();

    $('select.fancy').chosen({disable_search: true, width: '100%'});

    $('.example-searches').searchQueryPopulator({
      $searchField: $('input.query-field')
    });

    $('#search_flow .filterable-list').filterableList({
      trackingAction: 'create'
    });

    $('#add-service-form .filterable-list').filterableList({
      trackingAction: 'add'
    });

    $('#search_flow .filterable-list').submitLocalDeployment();

    $('ul.services li').serviceActions();

    $('section.application-services').serviceViews();

    $('#manage_flow section.applications').applicationActions();

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

    $('.exposed-ports').appendableExposePorts();

    $('.service-links').appendableServiceLinks();

    $('.port-bindings').appendablePortBindings();

    $('.mounted-containers').appendableVolumesFrom();

    $('.environment-variables dl.entries').editParameter({
      fieldSelector: 'dt.variable-name label',
      inputKey: 'input[data-index=name_%]'
    });

    $('.journal-output').journalLoader();

    $('.journal-log').journalToggle();

    $('[data-clipboard-text]').clipboard();

    $('.blog-feed-items').rssReader();

    $('.service-status').serviceStatus();

    $('.service-details .inspect').dockerInspect();

    $('.application-services').appServicesStatus();

    $('table.port-bindings tbody tr').portMappings();

    $('table.exposed-ports').exposedPorts();

    $('[data-accordian-expand]').accordian();

    $('body').toggleTargetClass();

    $('form.edit-registry').registryEditForm();

    $('.tab-container').fingerTabs();

    $('body').confirmAndDelete();

    $('body').confirmAndRedeploy();

    $('body').selectDeploymentTarget();

    $('[data-cancel-form]').cancelForm();

    $('#deployments_flow .deployment[data-show-path]').updatableContents({
      targetSelector: '.name',
      refreshedClass: 'contents-refreshed',
      urlDataAttribute: 'show-path',
      template: Handlebars.compile($('#deployment_template').html() || '')
    });

    $('#deployments_flow .deployment-settings').newRemoteDeployment({
      refreshPath: $('.deployment-metadata').data('refresh-path')
    });

    $('body').remoteContentsDialog({ targetSelector: '.provider a' });

    $('.initially-running .deployment-job-progress').updatableContentsPolling({
      refreshInterval: 5000
    });

    $('.initially-running .log-output').scrolliePollie({
      refreshInterval: 3000
    });

    $('.deployment-job').journalToggle({
      journalOutputSelector: '.log-output',
      journalTruncatedHeight: '0px',
      journalFullHeight: '300px',
      trigger: 'a.toggle-log'
    });

    (new $.PMX.destroyLink($('body'),
      {
        linkSelector: '.deployment-job a.delete-action',
        removeAt: '.deployment-job',
        disableWith: 'Removing...',
        fail: function(res, $target, context) {
          context.remove($target);
        }
      })).init();
  };
})(jQuery);
