describe('$.fn.healthGraph', function() {

  beforeEach(function() {
    fixture.load('host_health.html');
    subject = new $.PMX.HealthGraph($('.health'));
  });

  describe('#calculateHealth', function() {
    beforeEach(function() {
      spyOn(subject, 'healthColor');
      spyOn(subject, 'datumSize');
      subject.init();
    });
    it('calls healthColor', function() {
      subject.calculateHealth({ overall_cpu: 100, overall_mem: 100 });
      expect(subject.healthColor).toHaveBeenCalled();
    });

    it('calls datumSize', function() {
      subject.calculateHealth({ overall_cpu: 100, overall_mem: 100 });
      expect(subject.datumSize).toHaveBeenCalled();
    });
  });

  describe('#healthColor', function() {
    beforeEach(function() {
      spyOn(subject, 'colorLevel').andReturn('white');
      subject.init();
    });

    it('sets color level of the cpu details', function() {
      subject.healthColor($('.health'));
      expect(subject.colorLevel).toHaveBeenCalled();
      expect($('.health').hasClass('white')).toBeTruthy();
    });

    it('sets color level of the memory details', function() {
      subject.healthColor($('.health'));
      expect(subject.colorLevel).toHaveBeenCalled();
      expect($('.health').hasClass('white')).toBeTruthy();
    });
  });

  describe('#colorLevel', function() {
    it('returns danger when value is 90 or higher', function() {
      subject.init();
      result = subject.colorLevel(90);
      expect(result).toEqual('danger');
    });

    it('returns warning when value is 75 or higher', function() {
      subject.init();
      result = subject.colorLevel(80);
      expect(result).toEqual('warning');
    });

    it('returns good when value is below 75', function() {
      subject.init();
      result = subject.colorLevel(0);
      expect(result).toEqual('good');
    });
  });

});
