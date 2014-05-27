(function($){
  $.PMX.ServiceViewToggle = function(el, options){
    var base = this;

    base.$el = $(el);
    base.xhr = null;

    base.defaultOptions = {
      $panel: base.$el.find('.views'),
      listViewSelector: 'nav a.list',
      relationshipViewSelector: 'nav a.relationship'
    };

    base.init = function (){
      base.options = $.extend({}, base.defaultOptions, options);
      base.bindEvents();
    };

    base.bindEvents = function() {
      base.$el.on('click', base.options.listViewSelector, base.handleListView);
      base.$el.on('click', base.options.relationshipViewSelector, base.handleRelationshipView);
      base.watchCategories();
    };

    base.clearSelection = function(){
      base.$el.find(base.options.listViewSelector).removeClass('selected');
      base.$el.find(base.options.relationshipViewSelector).removeClass('selected');
    };

    base.applyAnimation = function($view, properties) {
      if (!$view.hasClass('selected')) {
        base.clearSelection();
        $view.addClass('selected');
        base.options.$panel
          .stop()
          .animate(properties, 800);
      }
    };

    base.watchCategories = function() {
      base.$el.unbind('service-event').on('service-event', function(e) {
        $.ajax({
          type: "GET",
          headers: {
            'Accept': 'application/json'
          },
          url: window.location.pathname + "/relations"
        })
          .done(function(response) {
            $('.relationships').empty().html(response);
          });
      });
    };

    base.handleListView = function(e){
      var $view = $(e.currentTarget);

      e.preventDefault();
      base.applyAnimation($view,
        {
          'right': '100%'
        });
    };

    base.handleRelationshipView = function(e){
      var $view = $(e.currentTarget);

      e.preventDefault();
      base.applyAnimation($view,
        {
          'right': '0'
        });
    };

  };

  $.fn.serviceViews = function(options){
    return this.each(function(){
      (new $.PMX.ServiceViewToggle(this, options)).init();
    });
  };
})(jQuery);
