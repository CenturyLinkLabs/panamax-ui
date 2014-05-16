describe('$.PMX.init', function() {

  describe('.environment-variables .additional-entries', function() {
    describe('#appendable', function() {
      beforeEach(function() {
        fixture.load('appendable.html');
      });

      beforeEach(function() {
        var fakeAdditonalItem = {
          $el: $('#row_template')
        }
        spyOn($.fn, 'appendable').andCallFake(function(options) {
          options.addCallback.call(this, fakeAdditonalItem);
        });
        $.PMX.init();
      });

      it('calls the appendable plugin', function() {
        expect($.fn.appendable).toHaveBeenCalledWith({
          $trigger: jasmine.any(Object),
          $elementToAppend: jasmine.any(Object),
          addCallback: jasmine.any(Function)
        });
      });

      it('replaces the _replaceme_ value in the inputs', function() {
        expect($('#row_template input').attr('name')).not.toMatch('replaceme');
      });
    });
  });

  describe('.port-detail .additional-entries', function() {
    describe('#appendable', function() {
      beforeEach(function() {
        fixture.load('appendable.html');
      });

      beforeEach(function() {
        $('#row_template input').prop('disabled', true);
        var fakeAdditonalItem = {
          $el: $('#row_template')
        }
        spyOn($.fn, 'appendable').andCallFake(function(options) {
          options.addCallback.call(this, fakeAdditonalItem);
        });
        $.PMX.init();
      });

      it('calls the appendable plugin', function() {
        expect($.fn.appendable).toHaveBeenCalledWith({
          $trigger: jasmine.any(Object),
          $elementToAppend: jasmine.any(Object),
          addCallback: jasmine.any(Function)
        });
      });

      it('replaces the _replaceme_ value in the inputs', function() {
        expect($('#row_template input').attr('name')).not.toMatch('replaceme');
      });

      it('re-enables disabled fields', function() {
        expect($('#row_template input').prop('disabled')).toBe(false)
      });
    });
  });

  describe('.service-links .additional-entries', function() {
    describe('#appendable', function() {
      beforeEach(function() {
        fixture.load('appendable.html');
      });

      beforeEach(function() {
        $('#row_template select').prop('disabled', true);
        var fakeAdditonalItem = {
          $el: $('#row_template')
        }
        spyOn($.fn, 'appendable').andCallFake(function(options) {
          options.addCallback.call(this, fakeAdditonalItem);
        });
        spyOn($.fn, 'chosen');
        $.PMX.init();
      });

      it('calls the appendable plugin', function() {
        expect($.fn.appendable).toHaveBeenCalledWith({
          $trigger: jasmine.any(Object),
          $elementToAppend: jasmine.any(Object),
          addCallback: jasmine.any(Function)
        });
      });

      it('replaces the _replaceme_ value in the inputs', function() {
        expect($('#row_template select').attr('name')).not.toMatch('replaceme');
      });

      it('re-enables disabled fields', function() {
        expect($('#row_template select').prop('disabled')).toBe(false)
      });

      it('instantiates chosen on the selects', function() {
        expect($.fn.chosen).toHaveBeenCalledWith({disable_search: true})
      });
    });
  });
});
