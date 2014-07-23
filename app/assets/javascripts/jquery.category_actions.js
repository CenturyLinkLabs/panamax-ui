//= require jquery.ui.dialog
//= require jquery.ui.sortable

(function($) {
  $.PMX.SortServices = function($el, options) {
    var base = this;

    base.$el = $el;

    base.defaultOptions = {
      connectWith: 'ul.services',
      dragHelper: '.dragging-service'
    };

    base.init = function() {
      base.options = $.extend({},base.defaultOptions, options);
      base.$sortable = base.$el.find(base.options.connectWith);
      base.bindSortable();
    };

    base.bindSortable = function() {
      $(base.$sortable).sortable(
        {
          appendTo: 'body',
          revert: true,
          connectWith: base.options.connectWith,
          placeholder: base.customPlaceholder(),
          helper: base.customHelper,
          start: base.startDrag,
          stop: base.stopDrag,
          update: base.drop
        });
    };

    base.customHelper = function(event, elem) {
      return $('<ul class="dragging-service"></ul>').append($(elem).clone());
    };

    base.customPlaceholder = function() {
      return {
        element: function () {
          return $('<li id="dragging"></li>')[0];
        },
        update: function (container, p) {
          // required to complete object interface
        }
      };
    };

    base.startDrag = function(event, ui) {
      var category = base.$el.find('[data-category]').attr('data-category');

      ui.placeholder.attr('data-category', category);
      ui.placeholder.html(ui.item.html());
    };

    base.stopDrag = function(event, ui) {
      $(base.options.dragHelper).remove();
    };

    base.drop = function(event, ui) {
      var targetPanel = ui.item.closest('.category-panel'),
          targetCategory = targetPanel.find('[data-category]').attr('data-category'),
          services = targetPanel.find('ul.services li'),
          path = window.location.pathname;

      services.each(function (idx, serviceEl) {
        var $elem = $(serviceEl),
            service_id = $elem.attr('data-id'),
            service = { id: service_id };

        if (targetCategory !== 'null') {
          service.category = targetCategory;
          service.position = idx;
        }

        $.ajax({
          type: 'PUT',
          headers: {
            'Accept': 'application/json'
          },
          url: path + '/services/' + $elem.attr('data-id'),
          data: {
            service: service
          }
        });
      });
    };
  };

  $.PMX.AddService = function($el, options) {
    var base = this;

    base.$el = $el;
    base.xhr = null;

    base.defaultOptions = {
      template: Handlebars.compile($('#service_template').html()),
      localImageSelector: '.local-image-results',
      remoteImageSelector: '.remote-image-results',
      categorySelector: '.category-form-field'
    };

    base.init = function() {
      base.options = $.extend({}, base.defaultOptions, options);
      base.bindEvents();
    };

    base.bindEvents= function() {
      base.interceptForm(base.options.localImageSelector);
      base.interceptForm(base.options.remoteImageSelector);
    };

    base.interceptForm = function(formSelector) {
      base.$el.find(formSelector).unbind('submit').on('submit', 'form', function(e) {
        e.preventDefault();
        $(e.currentTarget).find(base.options.categorySelector).val(base.options.category);
        base.processForm($(e.currentTarget));
      });
    };

    base.createNewElement = function($parent, name, id, icon) {
      // TODO: if possible we may want to generate this URL in ruby
      var path = window.location.pathname,
          app_id = path.substring(path.lastIndexOf("/")+1),
          $clone = $(base.options.template(
            { 'service_id': id,
              'app_id': app_id,
              'service_url': '/apps/' + app_id + '/services/' + id,
              'icon': icon,
              'name': name
            }));

      $clone.serviceActions();

      return $clone;
    };

    base.locateServices = function() {
      if (base.options.$target.find('.services').length === 0) {
        base.options.$target.find( "header" ).after('<ul class="services"></ul>');
      }
      return base.options.$target.find('.services');
    };

    base.handleAddSuccess = function(name, id, icon) {
      var $services = base.locateServices(),
          $service = base.createNewElement($services, name, id, icon);

      $services.append($service);
      base.options.complete($service);
    };

    base.processForm = function($form) {
      $.ajax({
        type: "POST",
        headers: {
          'Accept': 'application/json'
        },
        url: $form.attr('action'),
        data: $form.serialize()
      })
        .done(function(response) {
          var baseIconUrl = 'http://panamax.ca.tier3.io/service_icons/icon_service_docker_grey.png';
          var icon = response.icon || baseIconUrl;
          base.handleAddSuccess(response.name, response.id, icon);
        })
        .fail(function(){
          alert('Unable to add service.');
        });
    };
  };

  $.PMX.EditCategory = function(el, options) {
    var base = this;

    base.$el = el;
    base.defaultOptions = {
      content: 'span.title',
      editSelector: '.actions a.edit-action'
    };

    base.init = function() {
      base.options = $.extend({}, base.defaultOptions, options);
      base.bindEvents();

    };

    base.bindEvents = function() {
      base.$el.find(base.options.editSelector).on('click', base.handleEdit);
    };

    base.sortable = function(enabled) {
      var categories = base.$el.closest('.categories');
      (enabled) ? categories.sortable('enable') : categories.sortable('disable');
    };

    base.handleEdit = function(e) {
      var $target = $(e.currentTarget),
          $parent = $target.parent();

      e.preventDefault();
      base.sortable(false);
      $parent.css('display', 'none');
      base.editableName = (new $.PMX.ContentEditable(base.$el.find(base.options.content),
        {
          identifier: $target.attr('href'),
          onRevert: base.handleRevert,
          editorPromise: base.completeEdit
        })).init();
    };

    base.handleRevert = function(id) {
      var $link = base.$el.find('a[href="'+id+'"]');
      base.$el.find('.actions')[0].style.cssText = '';
      base.sortable(true);
    };

    base.updateCategory = function(path, data) {
      return $.ajax({
        type: "PUT",
        headers: {
          'Accept': 'application/json'
        },
        url: data.id,
        data: {
          category: {
            name: data.text
          }
        }
      })
      .success(function(){
        base.$el.find('.actions')[0].style.cssText = '';
      });
    };

    base.moveServicesToNamedCategory = function(path, data) {
      var transaction = $.Deferred(),
          update = function(serviceUrl, category) {
            return $.ajax({
              type: 'PUT',
              headers: {
                'Accept': 'application/json'
              },
              url: serviceUrl,
              data: {
                service: {
                  category: category.id
                }
              }
            });
          },
          create = function() {
            return $.ajax({
              type: "POST",
              headers: {
                'Accept': 'application/json'
              },
              url: path + "/categories",
              data: {
                category: {
                  name: data.text
                }
              }
            });
          },
          assign = function(category) {
            var $addData = base.$el.find('a[data-category="null"]'),
                $uncategorized = $addData.closest('.category-panel').find('ul.services li a.view-action'),
                serviceList = [];

            $addData.attr('data-category', ''+category.id);

            $uncategorized.each(function(idx) {
                serviceList.push( update($(this).attr('href'), category));
            });

            $.when.apply($, serviceList).done(function() {
              transaction.resolve();
            });
          };

          create()
            .success(assign)
            .fail(function() {
              transaction.reject();
            });

      return transaction.promise();
    };

    base.completeEdit = function(data) {
      var path = window.location.pathname;

      base.sortable(true);

      return (data.id.lastIndexOf('/') === data.id.length-1) ?
        base.moveServicesToNamedCategory(path, data) :
        base.updateCategory(path, data);
    };
  };

  $.PMX.AddServiceDialog = function(el) {
    var base = this;

    base.$el = el;
    base.xhr = null;

    base.defaultOptions = {
      $addServiceButton: $('a.add-service'),
      $modalContents: $('#add-service-form'),
      $dialogBox: $('.ui-dialog'),
      $titlebarCloseButton: $('button.ui-dialog-titlebar-close'),
      localImageSelector: '.local-image-results',
      remoteImageSelector: '.remote-image-results'
    };

    base.init = function() {
      base.bindEvents();
      base.initiateDialog();
    };

    base.bindEvents = function() {
      base.$el.on('click', base.defaultOptions.$addServiceButton.selector, base.showDialogForm);
    };

    base.showDialogForm = function (e) {
      var category = $(e.currentTarget).attr('data-category');
      e.preventDefault();
      new $.PMX.AddService(base.defaultOptions.$modalContents,
        {
          category: category,
          $target: base.$el,
          complete: function($clone){

            base.handleClose();
            $.PMX.addedAnimation($clone);
            base.$el.trigger('category-change');
          }
        }).init();

      $('body').css('overflow', 'hidden');
      base.defaultOptions.$modalContents.dialog("open");
      $('.ui-dialog-content').css('height', '');
    };

    base.handleClose = function() {
      base.defaultOptions.$modalContents.dialog("close");
      $(base.defaultOptions.localImageSelector).empty();
      $(base.defaultOptions.remoteImageSelector).empty();
      $('.query-field').val('');
      $('body').css('overflow', 'auto');
    };

    base.initiateDialog = function() {
      base.defaultOptions.$modalContents.dialog({
        autoOpen: false,
        modal: true,
        resizable: false,
        draggable: true,
        width: 860,
        position: ["top", 50],
        title: 'Search Images',
        close: base.handleClose,
        buttons: [
          {
            text: "Cancel",
            class: 'button-secondary',
            click: base.handleClose
          }
        ]
      });
    };
  };

  $.PMX.TrueCategoryPanel = function(options) {
    var base = this;

    base.defaultOptions = {
      archetype: Handlebars.compile($('#category_archetype').html())
    };

    base.init = function () {
      base.options = $.extend({}, base.defaultOptions, options);
      base.$el = $(base.options.archetype(options));
    };

    base.hydrate = function() {
      base.init();
      base.$el.categoryActions();

      return base.$el;
    };
  };

  $.PMX.NewCategoryPanel = function(options) {
    var base = this;

    base.defaultOptions = {
      cancelSelector: 'a.cancel.text',
      newCategoryTemplate: Handlebars.compile($('#new_category_template').html())
    };

    base.init = function () {
      base.options = $.extend({}, base.defaultOptions, options);
      base.$el = $(base.options.newCategoryTemplate({}));
      base.bindEvents();
      (new $.PMX.ContentEditable(base.$el.find('span.title'),{
        identifier: $.PMX.Helpers.guid(),
        onRevert: base.handleRevert,
        editorPromise: base.handleCommit
      })).init();
    };

    base.bindEvents = function() {
      base.$el.on('click', base.options.cancelSelector, base.handleCancel);
    };

    base.handleCancel = function(e) {
      e.preventDefault();
      base.$el.remove();
    };

    base.handleRevert = function(id) {
      base.$el.remove();
    };

    base.buildPanel = function(data) {
      var path = window.location.pathname,
          app = path.substring(path.lastIndexOf('/')+1),
          $template;

      data.app_id = app;
      $template = (new $.PMX.TrueCategoryPanel(data)).hydrate();

      base.$el.before($template);
      base.$el.remove();
      $.PMX.addedAnimation($template);
    };

    base.handleCommit = function(data) {
      var path = window.location.pathname;

      return $.ajax({
        type: "POST",
        headers: {
          'Accept': 'application/json'
        },
        url: path + "/categories",
        data: {
          category: {
            name: data.text
          }
        }
      })
      .done(function(response) {
        base.buildPanel(response);
      });
    };

    base.hydrate = function() {
      base.init();
      return base.$el;
    };
  };

  $.PMX.AddCategory = function(el, options) {
    var base = this;

    base.$el = el;

    base.defaultOptions = {
      addCategorySelector: '.button-positive.add-category'
    };

    base.init = function () {
      base.options = $.extend({}, base.defaultOptions, options);
      base.bindEvents();
    };

    base.bindEvents = function () {
      base.$el.on('click', base.options.addCategorySelector, base.handleAddCategory);
    };

    base.handleAddCategory = function(e) {
      base.$el.before((new $.PMX.NewCategoryPanel()).hydrate());
    };
  };

  $.PMX.DeleteCategory = function($el, options) {
    var base = this;

    base.$el = $el;

    base.defaultOptions = {
      removeSelector: '.category-panel',
      deleteCategorySelector: 'header .delete-action',
      tooltipSelector: '.services li',
      panelIdentifier: '[data-category]'
    };

    base.init = function () {
      base.options = $.extend({}, base.defaultOptions, options);
      base.bindEvents();
    };

    base.bindEvents = function () {
      base.$el.on('mouseenter', base.options.deleteCategorySelector, base.hoverOver);
      base.$el.on('mouseleave', base.options.deleteCategorySelector, base.hoverOut);
      base.$el.on('click', base.options.deleteCategorySelector, base.handleDelete);
    };

    base.hoverOver = function(e) {
      var $target = $(e.currentTarget);

      if (base.$el.find(base.options.tooltipSelector).length > 0 ) {
        $('<span class="tooltip">Categories must be empty.</span>').appendTo(base.$el);
        $target.addClass('disabled');
      }
    };

    base.hoverOut = function(e) {
      var $target = $(e.currentTarget);

      $target.removeClass('disabled');
      $('.category-panel .tooltip').remove();
    };

    base.confirmDelete = function(e) {
      var destroyer = new $.PMX.destroyLink(base.$el,
        {
          linkSelector: base.options.deleteCategorySelector,
          removeAt: base.options.removeSelector,
          success: function() {
            base.$el.remove();
          }
        });

      destroyer.init();
      destroyer.handleDelete(e);
    };

    base.handleDelete = function(e) {
      var $target = $(e.currentTarget),
        identifier = base.$el.find(base.options.panelIdentifier);

      e.preventDefault();
      if ( !($target.hasClass('disabled')) ) {
        (new $.PMX.ConfirmDelete($target.closest('header'),
          {
            message: 'Delete this category from your app?',
            confirm: function() {
              if (identifier.attr('data-category') === 'null') {
                base.$el.remove();
              } else {
                var fakeEvent = $.Event('click');
                fakeEvent.currentTarget = base.$el.find(base.options.deleteCategorySelector);
                base.confirmDelete(fakeEvent);
              }
            }
          }
        )).init();
      }
    };
  };

  $.fn.categoryActions = function(){
    return this.each(function(){
      (new $.PMX.AddServiceDialog($(this))).init();
      (new $.PMX.EditCategory($(this))).init();
      (new $.PMX.AddCategory($(this))).init();
      (new $.PMX.DeleteCategory($(this))).init();
      (new $.PMX.SortServices($(this))).init();
    });
  };
})(jQuery);
