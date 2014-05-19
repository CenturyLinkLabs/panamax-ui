describe('$.fn.noticeActions', function() {
  var subject;

  beforeEach(function () {
    fixture.load('notice-actions.html');
    subject = new $.PMX.NoticeDestroyer($('main'));
    subject.init();
  });

  describe('clicking dismiss', function() {
    it('removes the notice', function() {
      $('a.dismiss').click();
      expect($('section.notice div').css('opacity')).toBe('0.5');
    });
  });
});