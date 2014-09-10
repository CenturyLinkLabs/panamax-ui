(function($){
  $.PMX.DockerRunGenerator = function() {

    var options = arguments[0];
    options.links = options.links || [];
    options.portMappings = options.portMappings || [];
    options.exposePorts = options.exposePorts || [];
    options.environmentVars = options.environmentVars || [];
    options.volumes = options.volumes || [];

    var containerName = function() {
      return '--name ' + options.name;
    };

    var linkFlags = function() {
      var flags = [];

      for (var i = 0; i < options.links.length; i++) {
        var link = options.links[i];

        flags.push('--link ' + link.name + ':' + link.alias);
      }

      return flags;
    };

    var portFlags = function() {
      var flags = [];

      for (var i = 0; i < options.portMappings.length; i++) {
        var port = options.portMappings[i];
        var arg = [];

        if (port.hostPort) {
          arg.push(port.hostPort);
          arg.push(':');
        }
        arg.push(port.containerPort);

        if (port.proto && port.proto == 'UDP') {
          arg.push('/udp');
        }

        flags.push("-p " + arg.join(''));
      }

      return flags;
    };

    var exposeFlags = function() {
      var flags = [];

      for (var i = 0; i < options.exposedPorts.length; i++) {
        flags.push('--expose ' + options.exposedPorts[i]);
      }

      return flags;
    };

    var environmentFlags = function() {
      var flags = [];

      for (var i = 0; i < options.environment.length; i++) {
        var envVar = options.environment[i];
        var arg = [];

        arg.push('"');
        arg.push(envVar.name);
        arg.push('=');
        arg.push(envVar.value);
        arg.push('"');

        flags.push("-e " + arg.join(''));
      }

      return flags;
    };

    var volumeFlags = function() {
      var flags = [];

      for (var i = 0; i < options.volumes.length; i++) {
        var volume = options.volumes[i];
        var arg = [];

        if (volume.hostPath) {
          arg.push(volume.hostPath);
          arg.push(':');
        }

        arg.push(volume.containerPath);

        flags.push('-v ' + arg.join(''));
      }

      return flags;
    };

    var imageName = function() {
      return options.imageName;
    };

    var command = function() {
      return options.command;
    };

    this.toArray = function() {
      var parts = [
        'docker run',
        containerName(),
        linkFlags(),
        portFlags(),
        exposeFlags(),
        environmentFlags(),
        volumeFlags(),
        imageName(),
        command()
      ];

      // flatten array
      return [].concat.apply([], parts);
    };

    this.toString = function() {
      return this.toArray().join(' ');
    };
  };

})(jQuery);
