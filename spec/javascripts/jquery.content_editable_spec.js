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

  describe('user edits content', function() {
    it('updates the dirty flag', function() {
      $('span.title').text('Dirty');
      expect($('.checkmark').hasClass('dirty')).toBeTruthy
    });

    it('removes dirty flag when content returns to original', function() {
      $('span.title').text('Category');
      expect($('checkmark').hasClass('dirty')).toBeFalsy
    });

    it('clears invalid characters', function() {
      $('span.title').text('Dirty Stuff With\r\n');
      $('.checkmark').click();
      expect(subject.textOnly($('span.title'))).toEqual('Dirty Stuff With');
    })
  });

  describe('user clicks on checkmark', function() {
    it('calls revert if not dirty', function() {
      $('.checkmark').click();
      expect(reverted).toBeTruthy
    });

    it('calls commit if dirty', function() {
      $('span.title').text('Dirty');
      $('.checkmark').click();
      expect(completed).toBeTruthy
    });
  });

  describe('user clicks ENTER key', function() {
    var ENTER_KEY = 13,
      e = jQuery.Event("keydown");

    beforeEach(function() {
      e.which = ENTER_KEY;
    });

    it('calls revert if not dirty', function() {
      $("span.title").trigger(e);
      expect(reverted).toBeTruthy
    });

    it('calls commit if dirty', function() {
      $('span.title').text('Dirty');
      $("span.title").trigger(e);
      expect(completed).toBeTruthy
    });
  });

  describe('user clicks TAB key', function() {
    var TAB_KEY = 9,
      e = jQuery.Event("keydown");

    beforeEach(function() {
      e.which = TAB_KEY;
    });

    it('calls revert if not dirty', function() {
      $("span.title").trigger(e);
      expect(reverted).toBeTruthy
    });

    it('calls commit if dirty', function() {
      $('span.title').text('Dirty');
      $("span.title").trigger(e);
      expect(completed).toBeTruthy
    });
  });

  describe('when reverting', function() {
    beforeEach(function() {
      $('.checkmark').click();
    });

    it('removes contenteditable', function() {
      expect($('span.title').attr('contenteditable')).toBeFalsy
    });

    it('remove ".content-editable"', function() {
      expect($('span.title').hasClass('content-editable')).toBeFalsy
    });

    it('calls onRevert callback', function() {
      expect(reverted).toBeTruthy
    });
  });

  describe('when commiting a change', function() {
    beforeEach(function() {
      $('span.title').text('Dirty');
      $('.checkmark').click();
    });

    it('removes ".checkmark"', function() {
      expect($('.checkmark').length).toBe(0);
    });

    it('executes editorPromise', function() {
      expect(completed).toBeTruthy
    });

    it('reverts', function() {
      expect(reverted).toBeTruthy
    });
  });

});