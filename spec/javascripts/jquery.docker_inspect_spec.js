describe('$.fn.dockerInspect', function() {
  var subject, $contents;

  beforeEach(function() {
    fixture.load('docker-inspect.html');
    $contents = $('#docker-inspect');
    spyOn($.fn, 'dialog');
    spyOn(window, 'open');
    subject = new $.PMX.DockerInspect($('.inspect'));
    subject.init();
  });

  afterEach(function() {
    $('body').css('overflow', 'inherit');
  });

  describe('the inspect element', function () {

    it ('is hidden when status is not running', function() {
      spyOn(subject, 'hideLink');
      $('.service-status').trigger('update-service-status', {sub_state: 'loading'});

      expect(subject.hideLink).toHaveBeenCalled();
    });

    it('is shown when the status is running', function() {
      spyOn(subject, 'showLink');
      $('.service-status').trigger('update-service-status', {sub_state: 'running'});

      expect(subject.showLink).toHaveBeenCalled();
    });
  });

  describe('clicking on Docker Inspect', function() {

    it('prevents default behavior', function() {
      var clickEvent = $.Event('click');
      $('.inspect a').trigger(clickEvent);
      expect(clickEvent.isDefaultPrevented()).toBeTruthy();
    });

    it('displays the modal dialog', function() {
      $('.inspect a').click();
      expect($contents.dialog).toHaveBeenCalledWith('open');
    });
  });

  describe('clicking the New Browser Window button', function() {
    beforeEach(function() {
      spyOn(subject, 'insertInspectData');
    });

    it('opens new window', function() {
      subject.initiateDialog();
      subject.handleNewWindowOpen();

      expect(window.open).toHaveBeenCalled();
    });

    it('closes dialog', function() {
      subject.initiateDialog();
      subject.handleNewWindowOpen();

      expect($contents.dialog).toHaveBeenCalledWith('close');
    });
  });
});


