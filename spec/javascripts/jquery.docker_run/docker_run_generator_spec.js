describe('$.PMX.DockerRunGenerator', function() {
  var subject;
  var options = {
    name: 'MYSERVICE',
    links: [
      { name: 'MYSQL', alias: 'DB' }
    ],
    portMappings: [
      { hostPort: '1111', containerPort: '2222' },
      { containerPort: '3333', proto: 'UDP' }
    ],
    exposedPorts: [ '4444' ],
    environment: [
      { name: 'PATH', value: '/tmp' }
    ],
    volumes: [
      { hostPath: '/var/dir1', containerPath: '/var/dir2' },
      { containerPath: '/tmp/dir' }
    ],
    volumesFrom: [
      'fromVolume'
    ],
    imageName: 'foo/bar',
    command: '/bin/bash'
  };

  var expected = [
    'docker run',
    '--name MYSERVICE',
    '--link MYSQL:DB',
    '-p 1111:2222',
    '-p 3333/udp',
    '--expose 4444',
    '-e "PATH=/tmp"',
    '-v /var/dir1:/var/dir2',
    '-v /tmp/dir',
    '--volumes-from "fromVolume"',
    'foo/bar',
    '/bin/bash'
  ]

  beforeEach(function() {
    subject = new $.PMX.DockerRunGenerator(options);
  });

  describe('.toArray()', function() {
    it('returns an array of docker run flags', function() {
      expect(subject.toArray()).toEqual(expected);
    });
  });

  describe('.toString()', function() {
    it('returns a docker run string', function() {
      expect(subject.toString()).toEqual(expected.join(' '));
    });
  });
});
