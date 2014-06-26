(function($){
  $.PMX.SortCategories = function($el, options) {
    var base = this;

    base.$el = $el;

    base.defaultOptions = {
      container: 'div.categories',
      items: '> .category-panel:not(.add):not(.new):not(.edit)'
    };

    base.init = function() {
      base.options = $.extend({},base.defaultOptions, options);
      base.$sortable = base.$el.find(base.options.container);
      base.bindSortable();
    };

    base.bindSortable = function() {
      $(base.$sortable).sortable(
        {
          revert: true,
          helper: 'clone',
          items: base.options.items,
          placeholder: base.customPlaceholder(),
          start: base.startDrag,
          stop: base.stopDrag,
          update: base.drop,
          appendTo: 'body'
        });
    };

    base.customPlaceholder = function() {
      return {
        element: function () {
          return $('<div id="dragging" class="category-panel"></div>')[0];
        },
        update: function (container, p) {
          // required to complete object interface
        }
      };
    };

    base.startDrag = function(event, ui) {
      ui.item.removeClass('category-panel').wrap('<span class="cat-wrapper" style="display:none;"></span>')
      ui.placeholder.html(ui.item.html());
    };

    base.stopDrag = function(event, ui) {
      ui.item.addClass('category-panel');
      $('.cat-wrapper').remove();
    };

    base.drop = function(event, ui) {
      var categories = null,
          path = window.location.pathname;

      ui.item.addClass('category-panel');
      categories = base.$sortable.find(base.options.items),

      categories.each(function (idx, category) {
        var $elem = $(category),
          category_id = $elem.find('[data-category]').attr('data-category');
        if (category_id != 'null') {

          $.ajax({
            type: 'PUT',
            headers: {
              'Accept': 'application/json'
            },
            url: path + '/categories/' + category_id,
            data: {
              category: {
                position: idx
              }
            }
          });
        }
      });
    };
  };

  $.PMX.ServiceViewToggle = function($el, options){
    var base = this;

    base.$el = $el;
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
      base.$el.unbind('category-change').on('category-change', function(e) {
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
      (new $.PMX.ServiceViewToggle($(this), options)).init();
      (new $.PMX.SortCategories($(this),options)).init();
    });
  };
})(jQuery);
