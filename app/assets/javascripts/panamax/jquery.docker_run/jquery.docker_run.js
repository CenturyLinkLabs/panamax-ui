(function($){

  $.PMX.DockerRun = function(el, options){
    var base = this;

    base.$el = $(el);

    base.defaultOptions = {
      $output: $('#docker-string'),
      $containerName: $('.breadcrumbs ul li:last-of-type'),
      $imageName: $('#image-name'),
      $serviceCommand: $('#service_command'),
      serviceLinksSelector: '.service-links > ul > li:visible',
      linkNameSelector: '.link-name',
      linkAliasSelector: '.link-alias',
      portBindingsSelector: '.port-bindings > ul > li:visible',
      hostPortSelector: '.host-port',
      containerPortSelector: '.container-port',
      protoSelector: '.proto',
      exposedPortsSelector: '.exposed-ports .exposed-port:visible',
      environmentVarsSelector: '.environment-variables dl:visible',
      envVarNameSelector: '.variable-name',
      envVarValueSelector: '.variable-value',
      volumesSelector: '.volumes > ul > li:visible',
      volumeHostPathSelector: '.host-path',
      volumeContainerPathSelector: '.container-path',
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

        volumes.push({
          hostPath: base.extractText($hostPath),
          containerPath: base.extractText($containerPath)
        });
      });

      return volumes;
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
