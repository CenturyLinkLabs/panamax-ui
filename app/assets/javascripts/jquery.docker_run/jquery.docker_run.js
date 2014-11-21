(function($){

  $.PMX.DockerRun = function(el, options){
    var base = this;

    base.$el = $(el);

    base.defaultOptions = {
      $output: $('#docker-string'),
      $containerName: $('.breadcrumbs ul li:last-of-type'),
      $imageName: $('#image-name'),
      $serviceCommand: $('#service_command'),
      serviceLinksSelector: '.service-links > ul.entries > li',
      linkNameSelector: '.link-name',
      linkAliasSelector: '.link-alias',
      portBindingsSelector: '.port-bindings > ul > li:not(:first-of-type), table.port-bindings tr td',
      hostPortSelector: '.host-port',
      containerPortSelector: '.container-port',
      protoSelector: '.proto',
      exposedPortsSelector: '.exposed-ports span.exposed-port, div.exposed-ports .additional-entries li:not(:first-of-type) .exposed-port',
      environmentVarsSelector: '.environment-variables .entries, .environment-variables .additional-entries dl:not(:first-of-type)',
      envVarNameSelector: '.variable-name',
      envVarValueSelector: '.variable-value input',
      volumesSelector: '.volumes .data-containers > ul.entries li, .volumes .data-containers > ul.additional-entries > li:not(:first-of-type)',
      volumeHostPathSelector: '.host-path',
      volumeContainerPathSelector: 'input.container-path',
      volumesFromSelector: '.volumes .mounted-containers ul.entries li, .volumes .mounted-containers > ul.additional-entries > li:not(:first-of-type)',
      volumesFromMountSelector: '.mount-point',
      segmentWrapper: '<span class="run-segment">'
    };

    base.init = function(){
      base.options = $.extend({}, base.defaultOptions, options);
      base.bindEvents();
      base.generateDockerRunString();
    };

    base.bindEvents = function() {
      $('body').on('progressiveForm:changed', base.handleFormChange);
    };

    base.handleFormChange = function(e) {
      base.generateDockerRunString();
    };

    base.generateDockerRunString = function() {
      var $buffer = $('<div>');
      var opts = {
        name: base.containerName(),
        links: base.links(),
        portMappings: base.portMappings(),
        exposedPorts: base.exposedPorts(),
        environment: base.environment(),
        volumes: base.volumes(),
        volumesFrom: base.volumesFrom(),
        imageName: base.imageName(),
        command: base.command()
      };

      parts = (new $.PMX.DockerRunGenerator(opts)).toArray();

      $.each(parts, function(_, part) {
        $buffer.append($(base.options.segmentWrapper).text(part));
        $buffer.append(document.createTextNode(' '));
      });

      base.options.$output.html($buffer.html());
    };

    base.containerName = function() {
      return base.extractText(base.options.$containerName);
    };

    base.links = function() {
      var links = [];

      base.$el.find(base.options.serviceLinksSelector).each(function(_, element) {
        var $name = $(element).find(base.options.linkNameSelector);
        var $alias = $(element).find(base.options.linkAliasSelector);

        links.push({
          name: base.extractText($name),
          alias: base.extractText($alias)
        });
      });

      return links;
    };

    base.portMappings = function() {
      var ports = [];

      base.$el.find(base.options.portBindingsSelector).each(function(_, element) {
        var $hostPort = $(element).find(base.options.hostPortSelector);
        var $containerPort = $(element).find(base.options.containerPortSelector);
        var $proto = $(element).find(base.options.protoSelector);

        if ($containerPort.length == 1) {
          ports.push({
            hostPort: base.extractText($hostPort),
            containerPort: base.extractText($containerPort),
            proto: base.extractText($proto)
          });
        }
      });

      return ports;
    };

    base.exposedPorts = function() {
      var exposedPorts = [];

      base.$el.find(base.options.exposedPortsSelector).each(function(_, element) {
        exposedPorts.push(base.extractText($(element)));
      });

      return exposedPorts;
    };

    base.environment = function() {
      var environment = [];

      base.$el.find(base.options.environmentVarsSelector).each(function(_, element) {
        var $envName = $(element).find(base.options.envVarNameSelector);
        var $envValue = $(element).find(base.options.envVarValueSelector);

        environment.push({
          name: base.extractText($envName),
          value: base.extractText($envValue)
        });
      });

      return environment;
    };

    base.volumes = function() {
      var volumes = [];

      base.$el.find(base.options.volumesSelector).each(function(_, element) {
        var $hostPath = $(element).find(base.options.volumeHostPathSelector);
        var $containerPath = $(element).find(base.options.volumeContainerPathSelector);
        if ($containerPath.length == 1) {
          volumes.push({
            hostPath: ($hostPath.length == 1) ? base.extractText($hostPath) : '',
            containerPath: base.extractText($containerPath)
          });
        }
      });

      return volumes;
    };

    base.volumesFrom = function() {
      var volumes_from = [];

      base.$el.find(base.options.volumesFromSelector).each(function(_, element) {
        var $mount = $(element).find(base.options.volumesFromMountSelector);
        if ($mount.length == 1) {
          volumes_from.push(base.extractText($mount));
        }
      });
      return volumes_from;
    };

    base.imageName = function() {
      return base.extractText(base.options.$imageName);
    };

    base.command = function() {
      return base.extractText(base.options.$serviceCommand);
    };

    base.extractText = function($element) {
      var value;
      if ($element[0].tagName == 'INPUT') {
        value = $element.val();
      } else if ($element[0].tagName == 'SELECT') {
        value = $element.find('option:selected').text();
      } else {
        value = $element.text();
      }

      return value.trim();
    };
  };

  $.fn.dockerRun = function(options){
    return this.each(function(){
      (new $.PMX.DockerRun(this, options)).init();
    });
  };

})(jQuery);
