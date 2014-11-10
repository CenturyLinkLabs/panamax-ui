describe('$.PMX.SubmitLocalDeployment', function() {
  var subject;

  beforeEach(function () {
    fixture.load('submit-local-deployment.html');
    subject = new $.PMX.SubmitLocalDeployment('.select-target-container');
    subject.init();
  });

  describe('clicking on the local deployment button', function() {
    beforeEach(function() {
      $('.select-target-container button.link').click();
    });

    it('disables toggle class feature', function() {
      var target = $('.select-target-container  .select-target');
      expect(target.attr('data-toggle-class')).toBeUndefined();
      expect(target.hasClass('expanded')).toBeFalsy();
    });

    it('disables the element', function() {
      var target = $('.select-target-container  .select-target');
      expect(target.hasClass('disabled')).toBeTruthy();
    });

    it('sets the header text to Starting App...', function() {
      var header = $('.select-target-container  header');
      expect(header.text()).toEqual('Starting App...');
    });
  });
});
