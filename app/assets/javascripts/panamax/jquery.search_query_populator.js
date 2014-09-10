(function($){
  $.PMX.searchQueryPopulator = function(el, options){
    var base = this;

    base.$el = $(el);
    base.el = el;

    base.defaultOptions = {
      $searchField: $('input#search_query'),
      queryLinkSelector: 'a[data-query]'
    };

    base.init = function(){
      base.options = $.extend({}, base.defaultOptions, options);

      base.bindEvents();
    };

    base.bindEvents = function() {
      $(base.$el).on('click', base.options.queryLinkSelector, base.handleQueryClick);
    };

    base.handleQueryClick = function(e) {
      var query = $(e.currentTarget).data('query');
      base.updateSearchFieldWith(query);
      base.options.$searchField.focus();
      base.options.$searchField.closest("form").submit();
      base.$el.hide();
    };

    base.updateSearchFieldWith = function(query) {
      base.options.$searchField.val(query);
    };
  };

  $.fn.searchQueryPopulator = function(options){
    return this.each(function(){
      (new $.PMX.searchQueryPopulator(this, options)).init();
    });
  };

})(jQuery);
