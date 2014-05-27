//= require jquery.ui.dialog

(function($){
  $.PMX.AddService = function(el, options) {
    var base = this;

    base.$el = $(el);
    base.xhr = null;

    base.defaultOptions = {
      $template: $('.archetype li')
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
      var $clone = base.defaultOptions.$template.clone(),
          link = $clone.find('.actions a').attr('href');

      link = link.substring(0, link.lastIndexOf('/')+1);
      $clone.find('a[class^=status]').text(name);
      $clone.find('.actions a').attr('href',  link + id);
      $clone.find('.service-icon img').attr('src',  icon);
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
    }

    base.completeEdit = function(data) {
      var defer = $.Deferred();

      defer.done(function(data) {
        console.log('trying: ', data);
      });

      setTimeout(function() {defer.resolve(data);}, 3000);

      return defer.promise();
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
            var $indicateNew = $('<div class="indicate-new"></div>');

            base.handleClose();
            $clone.append($indicateNew);
            $indicateNew.fadeOut(2000);
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

  $.fn.categoryActions = function(){
    return this.each(function(){
      (new $.PMX.AddServiceDialog($(this))).init();
      (new $.PMX.EditCategory($(this))).init();
    });
  };
})(jQuery);
