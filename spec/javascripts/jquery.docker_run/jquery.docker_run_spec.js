describe('$.fn.dockerRun', function() {
  var subject,
      $serviceDetails;

  var dummyGenerator = {
    toArray: function() { return ['docker run']; }
  };

  var expectedOpts = {
    name: 'MYSERVICE',
    links: [
      { name: 'MYSQL', alias: 'DB' },
    ],
    portMappings: [
      { hostPort: '1111', containerPort: '2222', proto: 'TCP' }
    ],
    exposedPorts: [ '4444' ],
    environment: [
      { name: 'PATH', value: '/tmp' },
      { name: 'DEBUG', value: 'TRUE' }
    ],
    volumes: [
      { hostPath: '/var/dir1', containerPath: '/var/dir2' },
      { hostPath: '', containerPath: '/tmp/dir' }
    ],

    volumesFrom: [],

    imageName: 'foo/bar',
    command: '/bin/bash'
  };

  beforeEach(function() {
    fixture.load('docker-run.html');
    $serviceDetails = $('#teaspoon-fixtures').find('.service-details');
    subject = new $.PMX.DockerRun($serviceDetails);
    spyOn($.PMX, 'DockerRunGenerator').andReturn(dummyGenerator);
  });

  afterEach(function() {
    $('body').off();
  });

  describe('init', function() {

    it('instantiates the DockerRunGenerator with the proper arguments', function() {
      subject.init();

      var args = $.PMX.DockerRunGenerator.mostRecentCall.args[0];
      expect(args).toEqual(expectedOpts);
    });

    it('displays the docker run string', function() {
      subject.init();

      expect($('#docker-string').text().trim()).toEqual(
        dummyGenerator.toArray().join(''));
    });
  });

  describe('progressiveForm:changed fired', function() {

    beforeEach(function() {
      subject.init();
    });

    it('generates a new docker run string', function() {
      $('body').trigger('progressiveForm:changed');
      expect($.PMX.DockerRunGenerator.calls.length).toEqual(2);

      var args = $.PMX.DockerRunGenerator.mostRecentCall.args[0];
      expect(args).toEqual(expectedOpts);
    });
  });
});
