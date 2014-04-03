(function($){
  $.PMX.filterableList = function(el, options){
    var base = this;

    base.$el = $(el);
    base.el = el;

    base.defaultOptions = {
      queryFieldSelector: 'input#search_query',
      queryFormSelector: 'form',
      $queryForm: base.$el.find('form'),
      $results: base.$el.find('.search-results'),
      resultTemplate: Handlebars.compile($('#result_template').html())
    }

    base.init = function(){
      base.options = $.extend({}, base.defaultOptions, options);

      base.bindEvents();
    };

    base.bindEvents = function() {
      base.$el.on('keyup', base.options.queryFieldSelector, base.handleQueryChange);
      base.$el.on('submit', base.options.queryFormSelector, base.handleSubmit);
    };

    base.handleSubmit = function(e) {
      e.preventDefault();
    };

    base.handleQueryChange = function(e) {
      base.fetchResults();
    };

    base.fetchResults = function() {
      $.ajax({
        url: base.resultsEndpoint(),
        data: base.options.$queryForm.serialize()
      }).done(function(response, status) {
        base.updateResults(response);
      });
    };

    base.updateResults = function(results) {
      var resultsHtml = '';
      $.each(results.remote_images, function(i, image) {
        resultsHtml += base.options.resultTemplate(image);
      });
      base.options.$results.html(resultsHtml);
    };

    base.resultsEndpoint = function() {
      return base.options.$queryForm.attr('action') + '.json';
    };
  };

  $.fn.filterableList = function(options){
    return this.each(function(){
      (new $.PMX.filterableList(this, options)).init();
    });
  };

})(jQuery);
