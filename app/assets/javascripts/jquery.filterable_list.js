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

    base.defaultOptions = {
      $queryField: base.$el.find('input#search_query'),
      queryFormSelector: 'form',
      $queryForm: base.$el.find('form'),
      $imageResults: base.$el.find('.image-results'),
      $templateResults: base.$el.find('.template-results'),
      imageResultTemplate: Handlebars.compile($('#image_result_template').html()),
      templateResultTemplate: Handlebars.compile($('#template_result_template').html()),
      loadingTemplate: Handlebars.compile($('#loading_row_template').html()),
      noResultsTemplate: Handlebars.compile($('#no_results_row_template').html())
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
    };

    base.handleQueryChange = function(e) {
      base.fetchResults();
    };

    base.fetchResults = function(term) {
      base.displayLoadingIndicators();
      $.ajax({
        url: base.resultsEndpoint(),
        data: {'search_form[query]': term}
      }).done(function(response, status) {
        allImages = response.remote_images.concat(response.local_images);
        base.updateImageResults(allImages);
        base.updateTemplateResults(response.templates);
      });
    };

    base.updateImageResults = function(allImages) {
      var resultsHtml = '';
      $.each(allImages, function(i, image) {
        resultsHtml += base.options.imageResultTemplate(image);
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
