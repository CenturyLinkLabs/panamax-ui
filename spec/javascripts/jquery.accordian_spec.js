describe('$.fn.accordian', function() {
  beforeEach(function() {
    fixture.load('accordian.html');
    $('[data-accordian-expand]').accordian();
  });

  describe('on click', function() {
    it('hides the others and shows the target', function() {
      expect($('.thingy:visible').text().trim()).not.toEqual('expand third');
      $('#first a').click();
      expect($('.thingy:visible').text().trim()).toEqual('expand third');
      $('#second a').click();
      expect($('.thingy:visible').text().trim()).toEqual('expand first');
    });
  });
});
