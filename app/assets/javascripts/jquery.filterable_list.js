//= require jquery.ui.dialog

(function($){

  $.PMX.QueryField = function(el) {
    var base = this;

    base.$el = $(el);
    base.previousTerm = '';

    base.bindEvents = function() {
      base.$el.on('keyup', base.handleChange);
    };

    base.handleChange = function() {
      if (base.getTerm().length > 2 && base.getTerm() !== base.previousTerm) {
        base.changeCallback.call(base, base.getTerm());
        base.previousTerm = base.getTerm();
      }
    };

    base.onChange = function(callback) {
      base.changeCallback = callback;
    };

    base.getTerm = function() {
      return base.$el.val();
    };
  };


  $.PMX.SearchResults = function(url, limit) {
    var base = this;

    base.url = url;
    base.limit = limit;
    base.templatesXhr = null;
    base.localImagesXhr = null;
    base.remoteImagesXhr = null;

    base.fetch = function(term) {
      if (base.templatesXhr) { base.templatesXhr.abort(); }
      if (base.localImagesXhr) { base.localImagesXhr.abort(); }
      if (base.remoteImagesXhr) { base.remoteImagesXhr.abort(); }

      base.templatesXhr = base.fetchForType(term, 'template');
      base.localImagesXhr = base.fetchForType(term, 'local_image');
      base.remoteImagesXhr = base.fetchForType(term, 'remote_image');
    };

    base.templates = function(callback) {
      base.templatesXhr.done(function(response, status) {
        callback.call(this, response.templates);
      });
    };

    base.localImages = function(callback) {
      base.localImagesXhr.done(function(response, status) {
        callback.call(this, response.local_images);
      });
    };

    base.remoteImages = function(callback) {
      base.remoteImagesXhr.done(function(response, status) {
        callback.call(this, response.remote_images);
      });
    };

    base.fetchForType = function(term, type) {
      return $.ajax({
        url: base.url,
        data: {
          'search_result_set[q]': term,
          'search_result_set[type]': type,
          'search_result_set[limit]': base.limit
        }
      });
    };
  };

  $.PMX.TemplateDetailsDialog = function(el, options) {
    var base = this;

    base.$el = $(el);
    base.xhr = null;

    base.defaultOptions = {
      $modalContents: $('#template-details-dialog'),
      $titlebarCloseButton: $('button.ui-dialog-titlebar-close'),
      loadingTemplate: Handlebars.compile($('#loading_row_template').html())
    };

    base.init = function() {
      base.options = $.extend({}, base.defaultOptions, options);
      base.initiateDialog();
    };

    base.initiateDialog = function () {
      base.defaultOptions.$modalContents.dialog({
        dialogClass: 'template-details-dialog',
        autoOpen: false,
        modal: true,
        resizable: false,
        draggable: true,
        width: 860,
        position: ["top", 50],
        title: 'Template Details',
        close: base.handleClose,
        open: base.fetchTemplateDetails,
        buttons: [
          {
            text: "Run Template",
            class: 'button-positive',
            click: base.handleSubmit
          },
          {
            text: "Dismiss",
            class: 'button-secondary',
            click: base.handleClose
          }
        ]
      });
    };

    base.handleClose = function () {
      base.defaultOptions.$modalContents.dialog("close");
      base.options.$modalContents.html('');
      $('body').css('overflow', 'auto');
    };

    base.showTemplateDialog = function() {
      base.defaultOptions.$modalContents.dialog("open");
    };

    base.fetchTemplateDetails = function() {
      base.displayLoadingIndicator();
      if (base.xhr) {
        base.xhr.abort();
      }

      base.xhr = $.ajax({
        url: base.options.url,
        dataType: 'html'
      });

      base.xhr.done(function(response, status) {
        base.options.$modalContents.html(response);
      });
    };

    base.displayLoadingIndicator = function() {
      var forDetails = base.options.loadingTemplate({loading_copy: 'Loading Template Details'});
      base.options.$modalContents.html(forDetails);
    };

    base.handleSubmit = function(e) {
      e.preventDefault();
      var $templateRow = base.$el.closest('.template-result'),
          $actionsFormSubmit = $templateRow.find('form button');

      $actionsFormSubmit.click();
      base.handleClose();
    };
  };

  $.PMX.FilterableList = function(el, options) {
    var base = this;

    base.$el = $(el);

    base.defaultOptions = {
      $queryField: base.$el.find('input.query-field'),
      queryFormSelector: 'form.search-form',
      $queryForm: base.$el.find('form.search-form'),
      limit: 40,
      $localImageResults: base.$el.find('.local-image-results'),
      $remoteImageResults: base.$el.find('.remote-image-results'),
      $templateResults: base.$el.find('.template-results'),
      $resultHeadings: base.$el.find('.search-title'),
      remoteImageResultTemplate: Handlebars.compile($('#remote_image_result_template').html()),
      localImageResultTemplate: Handlebars.compile($('#local_image_result_template').html()),
      templateResultTemplate: Handlebars.compile($('#template_result_template').html()),
      loadingTemplate: Handlebars.compile($('#loading_row_template').html()),
      noResultsTemplate: Handlebars.compile($('#no_results_row_template').html()),
      sourceRepoBlurbTemplate: Handlebars.compile($('#source_blurb_row_template').html()),
      trackingAction: 'not-given',
      tagDropdownSelector: 'select.image-tag-select',
      chosenDropdownSelector: '.chosen-container',
      templateDetailsSelector: '.template-details-link'
    };

    base.init = function(){
      base.options = $.extend({}, base.defaultOptions, options);
      base.queryField = new $.PMX.QueryField(base.options.$queryField);
      base.queryField.bindEvents();
      base.searchResults = new $.PMX.SearchResults(base.resultsEndpoint(), base.options.limit);

      base.bindEvents();
    };

    base.bindEvents = function() {
      base.queryField.onChange(base.fetchResults);
      base.$el.on('submit', base.options.queryFormSelector, base.handleSubmit);
      base.$el.on('click', base.options.chosenDropdownSelector, base.fetchTags);
      base.$el.on('click', base.options.templateDetailsSelector, base.handleTemplateDetailsClick);
    };

    base.handleSubmit = function(e) {
      e.preventDefault();
      base.fetchResults(base.queryField.getTerm());
    };

    base.handleQueryChange = function(e) {
      base.fetchResults();
    };

    base.handleTemplateDetailsClick = function(e) {
      e.preventDefault();
      var $elem = $(e.target),
          template_id = $elem.attr('data-template-id'),
          modal = base.initTemplateDetailsDialog(template_id);
      modal.showTemplateDialog();
    };

    base.initTemplateDetailsDialog = function(template_id) {
      var origin = window.location.protocol + '//' + window.location.host,
        url = origin + '/templates/' + template_id + '/details',
        modal = new $.PMX.TemplateDetailsDialog(base.options.templateDetailsSelector, {url: url});

      modal.init();
      return modal;
    };

    base.fetchResults = function(term) {
      base.displayLoadingIndicators();
      base.options.$resultHeadings.css('display', 'block');
      PMX.Tracker.trackEvent('search', base.options.trackingAction, term);

      base.searchResults.fetch(term);
      base.searchResults.templates(base.loadTemplateResults);
      base.searchResults.localImages(base.loadLocalImageResults);
      base.searchResults.remoteImages(base.loadRemoteImageResults);
    };

    base.loadRemoteImageResults = function(images) {
      var resultsHtml = '';
      $.each(images, function(i, image) {
        resultsHtml += base.options.remoteImageResultTemplate(image);
      });
      base.options.$remoteImageResults.html(resultsHtml);
      base.displayTagDropdown();
    };

    base.loadLocalImageResults = function(images) {
      var resultsHtml = '';
      $.each(images, function(i, image) {
        resultsHtml += base.options.localImageResultTemplate(image);
      });
      base.options.$localImageResults.html(resultsHtml);
      base.displayTagDropdown();
    };

    base.loadTemplateResults = function(templates) {
      var resultsHtml = '';
      if (templates && templates.length) {
        $.each(templates, function(i, template) {
          resultsHtml += base.options.templateResultTemplate(template);
        });
      } else {
        resultsHtml = base.options.noResultsTemplate();
      }
      resultsHtml += base.options.sourceRepoBlurbTemplate();
      base.options.$templateResults.html(resultsHtml);
    };

    base.displayTagDropdown = function () {
      $(base.options.tagDropdownSelector).chosen({disable_search: true});
    };

    base.fetchTags = function (e) {
      var $elem = $(e.currentTarget),
          $resultRow = $elem.closest('.search-result-item'),
          $selectBox = $resultRow.find(base.options.tagDropdownSelector),
          loaded = $selectBox.data('loaded'),
          local_image = $resultRow.data('status-label') == 'Local';
      if (!loaded) {
        var tagsXhr = $.get(
          $(base.options.tagDropdownSelector).data('load-tags-endpoint'),
          { 'repo': $resultRow.data('title'), 'local_image': local_image }
        );

        tagsXhr.done(function (response) {
          $selectBox.empty();
          response.forEach(function (tag) {
            $selectBox.append('<option value="' + tag + '">' + tag + '</option>');
          });
          $selectBox.data('loaded', true);
          $selectBox.trigger("chosen:updated");
        });
      }
    };

    base.displayLoadingIndicators = function() {
      var forTemplates = base.options.loadingTemplate({loading_copy: 'Finding Templates'}),
          forLocalImages = base.options.loadingTemplate({loading_copy: 'Finding Images'}),
          forRemoteImages = base.options.loadingTemplate({loading_copy: 'Searching Docker Index'});
      base.options.$templateResults.html(forTemplates);
      base.options.$localImageResults.html(forLocalImages);
      base.options.$remoteImageResults.html(forRemoteImages);
    };

    base.resultsEndpoint = function() {
      return base.options.$queryForm.attr('action') + '.json';
    };
  };


  $.fn.filterableList = function(options){
    return this.each(function(){
      (new $.PMX.FilterableList(this, options)).init();
    });
  };

})(jQuery);
