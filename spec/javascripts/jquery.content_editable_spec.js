describe('$.fn.contentEditable', function() {
  var subject,
      reverted,
      completed;

  beforeEach(function() {
    fixture.load('content-editable.html');
    reverted = false;
    completed = false;
    subject = new $.PMX.ContentEditable($('span.title'),
      {
        identifier: '77',
        onRevert: function() {
          reverted = true;
        },
        editorPromise: function() {
          var defer = $.Deferred();

          defer.done(function() {
            completed = true;
          });

          return defer.promise();
        }
      });
    subject.init();
  });

  describe('content-editable was triggered', function() {
    it('adds the checkmark', function () {
      expect($('.checkmark').length).toEqual(1);
    });

    it('adds contenteditable', function() {
      expect($('*[contenteditable=true]').length).toEqual(1);
    });
  });

});