describe('$.fn.journalToggle', function() {
  var subject,
      $journalToggle,
      $journalOutput;

  beforeEach(function() {
    fixture.load('journal-loader.html');
    $journal = $('#teaspoon-fixtures').find('.overall-journal');
    $journalToggle = $('#teaspoon-fixtures').find('.journal-toggle');
    $journalOutput = $('#teaspoon-fixtures').find('.journal-output');

    subject = new $.PMX.JournalToggle($journal);
    subject.init();
  });

  describe('when the journal output is truncated', function() {

    beforeEach(function() {
      $journalOutput.addClass('truncated');
    });

    describe('clicking the toggle link', function() {

      it('removes the .truncated class from the journal output', function() {
        $journalToggle.click();
        expect($journalOutput.hasClass('truncated')).toBeFalsy();
      });

      it('adjusts the journal output to full height', function() {
        $journalToggle.click();
        expect($journalOutput.height()).toBe(
          parseInt(subject.options.journalFullHeight));
      });

      it('changes link text to "Hide Full Activity Log"', function() {
        $journalToggle.click();
        expect($journalToggle.text()).toBe('Hide Full Activity Log');
      });
    });
  });

  describe('when the journal output is not truncated', function() {

    beforeEach(function() {
      $journalOutput.removeClass('truncated');
      $journalToggle.text('Hide Full Activity Log');
      $journalToggle.data('alt-text', 'Show Full Activity Log');
    });

    describe('clicking the toggle link', function() {

      it('adds the .truncated class to the journal output', function() {
        $journalToggle.click();
        expect($journalOutput.hasClass('truncated')).toBeTruthy();
      });

      it('adjusts the journal output to truncated height', function() {
        $journalToggle.click();
        expect($journalOutput.height()).toBe(
          parseInt(subject.options.journalTruncatedHeight));
      });

      it('changes link text to "Show Full Activity Log"', function() {
        $journalToggle.click();
        expect($journalToggle.text()).toBe('Show Full Activity Log');
      });
    });
  });

});
