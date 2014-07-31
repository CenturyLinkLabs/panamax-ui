describe('$.fn.contextHelp', function() {
  var subject, toggleElement;

  beforeEach(function() {
    fixture.load('context-help.html');
    spyOn(window,'open');
    toggleElement = $('.context-help');
    subject = new $.PMX.ContextHelp(toggleElement);
    spyOn(subject, 'calculatePosition');
    subject.init();
  });

  describe('when context help element is clicked', function() {
    it('displays the content when hidden', function() {
      toggleElement.click();
      expect(toggleElement.hasClass('viewing')).toBeTruthy();
    });

    it('hides the content when visible', function() {
      toggleElement.addClass('viewing');
      toggleElement.click();
      expect(toggleElement.hasClass('viewing')).toBeFalsy();
    });

    it('evaluates the position of the context element', function() {
      toggleElement.click();
      expect(subject.calculatePosition).toHaveBeenCalled();
    });
  });

  describe('when content dismiss link is clicked', function() {
    it('closes the content', function() {
      var dismiss = $('.dismiss');
      toggleElement.addClass('viewing');
      dismiss.click();
      expect(toggleElement.hasClass('viewing')).toBeFalsy();
    });
  });

  describe('when a content link is clicked', function() {
    it('opens link in new window', function() {
      var link = $('.theLink');
      link.click();
      expect(window.open).toHaveBeenCalledWith('http://theserver/with/info','_blank');
    });
  });

  describe('when the browser is resized', function() {
    it('evaluates the position of the context element', function() {
      $(window).resize();
      expect(subject.calculatePosition).toHaveBeenCalled();
    });
  });
});
