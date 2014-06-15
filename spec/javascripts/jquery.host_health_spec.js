describe('$.fn.hostHealth', function() {
  var subject,
      overallResponse = [
        {
          'time_stamp': '1397167308398403'
        }
      ];

  beforeEach(function() {
    jasmine.Ajax.useMock();
    fixture.load('host_health.html');
    subject = new $.PMX.HostHealth($('.health'),
      {
        'goodColor': 'good',
        'warningColor': 'warning',
        'dangerColor': 'danger'
      });
    spyOn(window, 'setTimeout');
  });

  describe('#init', function() {
    it('queries for the overall metrics', function() {
      subject.init();
      var request = mostRecentAjaxRequest();
      expect(request.url).toBe('/metrics/overall');
    });

    it('initiates setTimeout', function() {
      subject.init();
      var request = mostRecentAjaxRequest();

      request.response({
        status: 200,
        responseText: ''
      });
      expect(window.setTimeout).toHaveBeenCalled();
    });
  });

  describe('clicking on root element', function() {
    it('adds the "showing" class', function() {
      subject.init();
      $('.health').click();
      expect($('.health').hasClass('showing')).toBeTruthy
    });

    it('removes "showing" if element has class', function() {
      var $elem = $('.health');
      subject.init();
      $elem.addClass('showing');
      $elem.click();
      expect($elem.hasClass('showing')).toBeFalsy
    });

    it('displays details when showing', function() {
      subject.init();
      $('.health').click();
      expect($('.health').find('.details')).toBeDefined
    });
  });

  describe('#healthColors', function() {
    beforeEach(function() {
      spyOn(subject, 'colorLevel').andReturn('white');
      subject.init();
      subject.healthColors();
    });

    it('sets color level of the root element', function() {
      expect(subject.colorLevel).toHaveBeenCalled();
      expect($('.health').css('background-color')).toEqual('rgb(255, 255, 255)');
    });

    it('sets color level of the cpu details', function() {
      $('.health').click();
      expect(subject.colorLevel).toHaveBeenCalled();
      expect($('.cpu .health').css('background-color')).toEqual('rgb(255, 255, 255)');
    });

    it('sets color level of the memory details', function() {
      $('.health').click();
      expect(subject.colorLevel).toHaveBeenCalled();
      expect($('.memory .health').css('background-color')).toEqual('rgb(255, 255, 255)');
    });
  });

  describe('#colorLevel', function() {
    it('returns danger when value is 90 or higher', function() {
      subject.init();
      result = subject.colorLevel(90);
      expect(result).toEqual('danger');
    });

    it('returns warning when value is 90 or higher', function() {
      subject.init();
      result = subject.colorLevel(80);
      expect(result).toEqual('warning');
    });

    it('returns good when value is below 80', function() {
      subject.init();
      result = subject.colorLevel(0);
      expect(result).toEqual('good');
    });
  });
});
