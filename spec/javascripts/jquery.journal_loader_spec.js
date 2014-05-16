describe('$.fn.journalLoader', function() {
  var subject,
      $journalOutput;

  var journalResponse = [
    {
      'MESSAGE': 'some message',
      'SYSLOG_IDENTIFIER': 'docker',
      '__REALTIME_TIMESTAMP': '1397167308398403',
      '__CURSOR': 'cursor1'
    }
  ];

  beforeEach(function() {
    jasmine.Ajax.useMock();
    fixture.load('journal-loader.html');
    $journalOutput = $('#teaspoon-fixtures').find('.journal-output');
    subject = new $.PMX.JournalLoader($journalOutput);
    spyOn(window, 'setTimeout');
  });

  describe('init', function() {

    it('queries the journal endpoint', function() {
      subject.init();
      var request = mostRecentAjaxRequest();
      expect(request.url).toBe('/journal?cursor=');
    });

    it('displays the formatted journal', function() {
      subject.init();
      var request = mostRecentAjaxRequest();

      request.response({
        status: 200,
        responseText: JSON.stringify(journalResponse)
      });

      expect($('.journal-output').text()).toContain(journalResponse[0]['MESSAGE']);
      expect($('.journal-output').text()).toContain(journalResponse[0]['SYSLOG_IDENTIFIER']);

      seconds = Math.floor(parseInt(journalResponse[0]['__REALTIME_TIMESTAMP']) / 1000);
      expect($('.journal-output').text()).toContain(moment(seconds).format("MMM DD HH:mm:ss"));
    });

    it('saves the cursor of the last journal line', function() {
      subject.init();
      var request = mostRecentAjaxRequest();

      request.response({
        status: 200,
        responseText: JSON.stringify(journalResponse)
      });

      expect(subject.cursor).toBe(journalResponse[0]['__CURSOR']);
    });

    it('calls window.setTimeout', function() {
      subject.init();
      var request = mostRecentAjaxRequest();

      request.response({
        status: 200,
        responseText: JSON.stringify(journalResponse)
      });

      expect(window.setTimeout).toHaveBeenCalledWith(
        subject.fetchJournal, subject.options.refreshInterval);
    });
  });

});
