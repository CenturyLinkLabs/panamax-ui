(function($) {
  $.PMX.EditService = function($el, options) {
    var base = this;

    base.$el = $el;
    base.xhr = null;

    base.defaultOptions = {
      editSelector: '.actions .edit-action',
      content: 'a[title=service-details]',
      editingService: 'editing-service',
      actionsSelector: '.actions',
      serviceIconSelector: '.service-icon'
    };

    base.init = function() {
      base.options = $.extend({}, base.defaultOptions, options);
      base.bindEvents();
    };

    base.bindEvents = function() {
      base.$el.on('click', base.options.editSelector, base.handleEdit);
    };

    base.hideExtras = function() {
      base.$el.find(base.options.serviceIconSelector).hide();
      base.$el.find(base.options.actionsSelector).hide();
      base.$el.find(base.options.content).hide();
      base.disableDrag();
    };

    base.showExtras = function() {
      base.$el.find(base.options.actionsSelector)[0].style.cssText = '';
      base.$el.find(base.options.serviceIconSelector)[0].style.cssText = '';
      base.$el.find(base.options.actionsSelector)[0].style.cssText = '';
      base.$el.find(base.options.content)[0].style.cssText = '';
      base.enableDrag();
    };

    base.disableDrag = function() {
      $(document).trigger('disable-sorting');
    };

    base.enableDrag = function() {
      $(document).trigger('enable-sorting');
    };

    base.handleEdit = function(e) {
      e.preventDefault();
      base.hideExtras();
      base.buildContainer();
    };

    base.buildContainer = function() {
      var $service = base.$el.find(base.options.content),
        $container = $('<div class="'+ base.options.editingService + '">'+ $service.html() +'</div>');

      base.$el.append($container);
      base.generateEditField($container);
    };

    base.generateEditField = function($container) {
      base.editableName = new $.PMX.ContentEditable($container,
        {
          identifier: base.$el.attr('data-id'),
          onRevert: base.handleRevert,
          editorPromise: base.completeEdit
        });
      base.editableName.init();
    };

    base.handleRevert = function() {
      base.$el.find('.'+base.options.editingService).remove();
      base.showExtras();
    };

    base.completeEdit = function(data) {
      var edit = base.$el.find(base.options.editSelector);
      return $.ajax({
        type: 'PUT',
        headers: {
          'Accept': 'application/json'
        },
        url: edit.attr('href'),
        data: {
          service: {
            name: data.text
          }
        }
      }).success(function() {
        // jQuery setting inline style this is better cross browser way to remove that //
        base.$el.find(base.options.content).text(data.text);
        base.showExtras();
      });
    };
  };

  $.PMX.ServiceDestroyer = function($el, options){
    var base = this;

    base.$el = $el;
    base.xhr = null;

    base.defaultOptions = {
    };

    base.init = function () {
      base.options = $.extend({}, base.defaultOptions, options);
      (new $.PMX.destroyLink(base.$el, {success: base.cleanList })).init();
    };

    base.cleanList = function () {
      var $services = base.$el.parent();

      base.$el.trigger('category-change');
      base.$el.remove();
      if ($services.find('li').length === 0) {
        $services.remove();
      }
    };
  };


  $.PMX.ServiceNameDisplay = function($el, options){
    var base = this;

    base.$el = $el;
    base.xhr = null;

    base.defaultOptions = {
      $serviceLink: base.$el.find('a').first(),
      tooltipSelector: '.tooltip'
    };

    base.init = function () {
      base.options = $.extend({}, base.defaultOptions, options);
      base.$el.on('mouseenter', base.options.$serviceLink, base.showServiceName);
      base.$el.on('mouseleave', base.options.$serviceLink, base.hideServiceName);
      base.$el.on('mousedown', base.hideServiceName);
    };

    base.showServiceName = function () {
      if ($(base.options.$serviceLink).html().length > 24) {
        $('<span class="tooltip">' + base.options.$serviceLink.html() + '</span>').appendTo(base.$el);
      }
    };

    base.hideServiceName = function () {
      base.$el.find('.tooltip').remove();
    };
  };

  $.fn.serviceActions = function(options) {
    return this.each(function() {
      (new $.PMX.ServiceDestroyer($(this), options)).init();
      (new $.PMX.ServiceNameDisplay($(this), options)).init();
      (new $.PMX.EditService($(this), options)).init();
    });
  };
})(jQuery);
