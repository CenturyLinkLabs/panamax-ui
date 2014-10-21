describe('$.fn.fingerTabs', function() {
  var subject;

  beforeEach(function() {
    fixture.load('finger-tabs.html');
    subject = new $.PMX.FingerTabs($('.tab-container'),
      {
        updateFormEvent: {
          event: 'formChange',
          target: '.tab-container'
        }
      });
  });

  it('sets first tab active', function() {
    var first = $('.tab-container .tab').first();
    expect(first.hasClass('active')).toBeFalsy();
    subject.init();
    expect(first.hasClass('active')).toBeTruthy();
  });

  describe('when clicking on a tab', function() {

    it('resets tabs to inactive state', function() {
      var last = $('.tab-container .tab').last(),
          first = $('.tab-container .tab').first();
      subject.init();
      last.addClass('active');
      first.click();
      expect(last.hasClass('active')).toBeFalsy();

    });

    it('add active class to tab', function() {
      var last = $('.tab-container .tab').last();
      subject.init();
      last.click();
      expect(last.hasClass('active')).toBeTruthy();
    });

    it('add active class to card', function() {
      var last = $('.tab-container .tab').last(),
          card = $('.tab-container .card').last();
      subject.init();
      last.click();
      expect(card.hasClass('active')).toBeTruthy();
    });
  });

  describe('when clicking on hide', function() {
    it('adds class slim when not present', function() {
      var tabs = $('.tab-container .tabs');
      tabs.addClass('slim');
      $('.tab-container .hide').click();
      expect(tabs.hasClass('slim')).toBeTruthy();
    });

    it('removes class slim when present', function() {
      var tabs = $('.tab-container .tabs');
      tabs.addClass('slim');
      $('.tab-container .hide').click();
      expect(tabs.hasClass('slim')).toBeTruthy();
    });
  });

  describe('when updateFormEvent', function() {
    it('adds changed class to active tab icon', function() {
      var icon;
      subject.init();
      icon = $('.tab-container .tab.active .icon');
      $('.tab-container').trigger('formChange');
      expect(icon.hasClass('changed')).toBeTruthy();
    });
  })
});
