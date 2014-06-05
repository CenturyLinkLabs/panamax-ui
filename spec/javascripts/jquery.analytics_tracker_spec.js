describe('$.fn.analyticsClickTracker', function() {
  beforeEach(function() {
    spyOn(PMX.Console, 'log');
    spyOn(window, 'gaTracker');
    fixture.load('analytics_tracker.html');
    $trigger = $('[data-tracking-method="click"]')
    $('body').analyticsClickTracker();
  });

  describe('clicking a link with click tracking enabled', function() {
    it('logs the category, action, and label', function() {
      $trigger.click();
      expect(PMX.Console.log).toHaveBeenCalledWith(['send', 'event', 'search', 'take search action', 'perform search label']);
    });

    it('pushes the category, action, and label to the google analytics tracker', function() {
      $trigger.click();
      expect(window.gaTracker).toHaveBeenCalledWith('send', 'event', 'search', 'take search action', 'perform search label');
    });

    it('does not prevent default', function() {
      var clickEvent = $.Event('click');
      $trigger.trigger(clickEvent);
      expect(clickEvent.isDefaultPrevented()).toBe(false);
    });
  });

});
