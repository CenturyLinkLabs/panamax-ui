//= require jquery.ui.dialog

(function($){
  $.PMX.AddService = function(el, options) {
    var base = this;

    base.$el = $(el);
    base.xhr = null;

    base.defaultOptions = {
      template: Handlebars.compile($('#service_template').html())
    };

    base.init = function() {
      base.options = $.extend({}, base.defaultOptions, options);
      base.bindEvents();
    };

    base.bindEvents= function() {
      base.$el.find('.image-results').unbind('submit').on('submit', 'form', function(e) {
        e.preventDefault();
        $(e.currentTarget).find('#application_category').val(base.options.category);
        base.processForm($(e.currentTarget));
      });
    };

    base.createNewElement = function($parent, name, id, icon) {
      var path = window.location.pathname,
          app_id = path.substring(path.lastIndexOf("/")+1),
          $clone = $(base.options.template(
            { 'service_id': id,
              'app_id': app_id,
              'service_url': '/applications/' + app_id + '/services/' + id,
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

    base.handleEdit = function(e) {
      var $target = $(e.currentTarget),
          $parent = $target.parent();

      e.preventDefault();
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
      $link.closest('.actions').css('display','auto');
    };

    base.updateCategory = function(path, data) {
      return $.ajax({
        type: "PUT",
        headers: {
          'Accept': 'application/json'
        },
        url: path + data.id,
        data: {
          category: {
            name: data.text
          }
        }
      })
      .fail(function(){
        alert('Unable to edit category.');
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

      return (data.id.lastIndexOf('/') === data.id.length-1)
        ? base.moveServicesToNamedCategory(path, data)
        : base.updateCategory(path, data);
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
      $titlebarCloseButton: $('button.ui-dialog-titlebar-close')
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
      $('.image-results').empty();
      $('#search_form_query').val('');
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
    }
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
        console.log('data: ', response);
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
      deleteCategorySelector: 'header .delete-action'
    };

    base.init = function () {
      base.options = $.extend({}, base.defaultOptions, options);
      base.bindEvents();
    };

    base.bindEvents = function () {
      base.$el.on('mouseenter mouseleave', base.options.deleteCategorySelector, base.handleHover);
      base.$el.on('click', base.options.deleteCategorySelector, base.handleDelete);
    };

    base.hoverOver = function($target) {
      if (base.$el.find(".services li").length > 0) {
        $('<span class="tooltip">Categories must be empty.</span>').appendTo(base.$el);
        $target.addClass('disabled');
      }
    };

    base.hoverOut = function($target) {
      $target.removeClass('disabled');
      $('.category-panel .tooltip').remove();
    };

    base.handleHover = function(e) {
      var $target = $(e.currentTarget),
          type = e.type;

      switch(type) {
        case 'mouseenter':
          base.hoverOver($target);
          break;
        case 'mouseleave':
          base.hoverOut($target);
          break;
      }
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
      var $target = $(e.currentTarget);

      e.preventDefault();
      if ( !($target.hasClass('disabled')) ) {
        (new $.PMX.ConfirmDelete($target.closest('header'),
          {
            message: 'Delete this category from your app?',
            confirm: function() {
              var fakeEvent = $.Event('click');
              fakeEvent.currentTarget = base.$el.find(base.options.deleteCategorySelector);
              base.confirmDelete(fakeEvent);
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
    });
  };
})(jQuery);
