(function($){

  $.PMX.QueryField = function(el) {
    var base = this;

    base.$el = $(el);
    base.previousTerm = '';

    base.bindEvents = function() {
      base.$el.on('keyup', base.handleChange);
    };

    base.handleChange = function() {
      if (base.getTerm().length > 2 && base.getTerm() != base.previousTerm) {
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


  $.PMX.FilterableList = function(el, options){
    var base = this;

    base.$el = $(el);
    base.xhr = null;

    base.defaultOptions = {
      $queryField: base.$el.find('input#search_form_query'),
      queryFormSelector: 'form.search-form',
      $queryForm: base.$el.find('form.search-form'),
      $imageResults: base.$el.find('.image-results'),
      $templateResults: base.$el.find('.template-results'),
      $resultHeadings: base.$el.find('.search-title'),
      remoteImageResultTemplate: Handlebars.compile($('#remote_image_result_template').html()),
      localImageResultTemplate: Handlebars.compile($('#local_image_result_template').html()),
      templateResultTemplate: Handlebars.compile($('#template_result_template').html()),
      loadingTemplate: Handlebars.compile($('#loading_row_template').html()),
      noResultsTemplate: Handlebars.compile($('#no_results_row_template').html()),
      trackingAction: 'not-given'
    }

    base.init = function(){
      base.options = $.extend({}, base.defaultOptions, options);
      base.queryField = new $.PMX.QueryField(base.options.$queryField);
      base.queryField.bindEvents();

      base.bindEvents();
    };

    base.bindEvents = function() {
      base.queryField.onChange(base.fetchResults);
      base.$el.on('submit', base.options.queryFormSelector, base.handleSubmit);
    };

    base.handleSubmit = function(e) {
      e.preventDefault();
      base.fetchResults(base.queryField.getTerm());
      base.options.$resultHeadings.css('display', 'block');
    };

    base.handleQueryChange = function(e) {
      base.fetchResults();
    };

    base.fetchResults = function(term) {
      base.displayLoadingIndicators();
      PMX.Tracker.trackEvent('search', base.options.trackingAction, term);

      if (base.xhr) {
        base.xhr.abort();
      }

      base.xhr = $.ajax({
        url: base.resultsEndpoint(),
        data: {'search_form[query]': term}
      });

      base.xhr.done(function(response, status) {
        base.updateImageResults(response.remote_images, response.local_images);
        base.updateTemplateResults(response.templates);
        base.displayTagDropdown();
      });
    };

    base.updateImageResults = function(remoteImages, localImages) {
      var resultsHtml = '';
      $.each(localImages, function(i, image) {
        resultsHtml += base.options.localImageResultTemplate(image);
      });
      $.each(remoteImages, function(i, image) {
        resultsHtml += base.options.remoteImageResultTemplate(image);
      });
      base.options.$imageResults.html(resultsHtml);
    };

    base.updateTemplateResults = function(templates) {
      var resultsHtml = '';
      if (templates && templates.length) {
        $.each(templates, function(i, template) {
          resultsHtml += base.options.templateResultTemplate(template);
        });
      } else {
        resultsHtml = base.options.noResultsTemplate();
      }
      base.options.$templateResults.html(resultsHtml);
    };

    base.displayTagDropdown = function () {
      var $tagDropdown = $('select#tags')
      $tagDropdown.chosen({disable_search: true});
    }

    base.displayLoadingIndicators = function() {
      var forTemplates = base.options.loadingTemplate({loading_copy: 'Finding Templates'}),
          forImages = base.options.loadingTemplate({loading_copy: 'Finding Images'});
      base.options.$templateResults.html(forTemplates);
      base.options.$imageResults.html(forImages);
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
