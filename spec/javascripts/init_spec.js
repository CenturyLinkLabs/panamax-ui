describe('$.PMX.init', function() {

  describe('.environment-variables .additional-entries', function() {
    describe('#appendable', function() {
      beforeEach(function() {
        fixture.load('appendable_env_vars.html');

        var fakeAdditonalItem = {
          $el: $('#row_template')
        }

        spyOn($.PMX, 'Appendable').andCallFake(function($el, options) {
          return {
            init: function() {
              options.addCallback.call(this, fakeAdditonalItem);
            }
          }
        });

        $.PMX.init();
      });

      it('calls the appendable plugin with the appropriate base element', function() {
        var nativeDomEl = $.PMX.Appendable.mostRecentCall.args[0][0];
        expect(nativeDomEl.length).toBe();
        expect(nativeDomEl).toEqual($('.environment-variables .additional-entries')[0]);
      });

      it('calls the appendable plugin with the appropriate trigger', function() {
        var nativeDomEl = $.PMX.Appendable.mostRecentCall.args[1].$trigger[0];
        expect(nativeDomEl.length).toBe();
        expect(nativeDomEl).toEqual($('.environment-variables .button-add')[0]);
      });

      it('calls the appendable plugin with the appropriate elementToAppend', function() {
        var elToAppend = $.PMX.Appendable.mostRecentCall.args[1].$elementToAppend;
        expect(elToAppend.text()).toContain('PASSWORD');
        expect(elToAppend.text()).toContain('abc123');
      });

      it('replaces the _replaceme_ value in the inputs', function() {
        expect($('#row_template input').attr('name')).not.toMatch('replaceme');
      });

      it('re-enables disabled fields', function() {
        expect($('#row_template input').prop('disabled')).toBe(false)
      });
    });
  });

  describe('.port-bindings .additional-entries', function() {
    describe('#appendable', function() {
      beforeEach(function() {
        fixture.load('appendable-port-bindings.html');
      });

      beforeEach(function() {
        $('#row_template input').prop('disabled', true);
        var fakeAdditonalItem = {
          $el: $('#row_template')
        }

        spyOn($.PMX, 'Appendable').andCallFake(function($el, options) {
          return {
            init: function() {
              options.addCallback.call(this, fakeAdditonalItem);
            }
          }
        });
        $.PMX.init();
      });

      it('calls the appendable plugin with the appropriate base element', function() {
        var nativeDomEl = $.PMX.Appendable.mostRecentCall.args[0][0];
        expect(nativeDomEl.length).toBe();
        expect(nativeDomEl).toEqual($('.port-bindings .additional-entries')[0]);
      });

      it('calls the appendable plugin with the appropriate trigger', function() {
        var nativeDomEl = $.PMX.Appendable.mostRecentCall.args[1].$trigger[0];
        expect(nativeDomEl.length).toBe();
        expect(nativeDomEl).toEqual($('.port-bindings .button-add')[0]);
      });

      it('calls the appendable plugin with the appropriate elementToAppend', function() {
        var elToAppend = $.PMX.Appendable.mostRecentCall.args[1].$elementToAppend;
        expect(elToAppend.html()).toEqual('first thing');
      });

      it('replaces the _replaceme_ value in the inputs', function() {
        expect($('#row_template input').attr('name')).not.toMatch('replaceme');
      });

      it('re-enables disabled fields', function() {
        expect($('#row_template input').prop('disabled')).toBe(false)
      });
    });
  });

  describe('.exposed-ports .additional-entries', function() {
    describe('#appendable', function() {
      beforeEach(function() {
        fixture.load('appendable-exposed-ports.html');
      });

      beforeEach(function() {
        $('#row_template input').prop('disabled', true);
        var fakeAdditonalItem = {
          $el: $('#row_template')
        }

        spyOn($.PMX, 'Appendable').andCallFake(function($el, options) {
          return {
            init: function() {
              options.addCallback.call(this, fakeAdditonalItem);
            }
          }
        });
        $.PMX.init();
      });

      it('calls the appendable plugin with the appropriate base element', function() {
        var nativeDomEl = $.PMX.Appendable.mostRecentCall.args[0][0];
        expect(nativeDomEl.length).toBe();
        expect(nativeDomEl).toEqual($('.exposed-ports  .additional-entries')[0]);
      });

      it('calls the appendable plugin with the appropriate trigger', function() {
        var nativeDomEl = $.PMX.Appendable.mostRecentCall.args[1].$trigger[0];
        expect(nativeDomEl.length).toBe();
        expect(nativeDomEl).toEqual($('.exposed-ports .button-add')[0]);
      });

      it('calls the appendable plugin with the appropriate elementToAppend', function() {
        var elToAppend = $.PMX.Appendable.mostRecentCall.args[1].$elementToAppend;
        expect(elToAppend.html()).toEqual('first thing');
      });

      it('replaces the _replaceme_ value in the inputs', function() {
        expect($('#row_template input').attr('name')).not.toMatch('replaceme');
      });

      it('re-enables disabled fields', function() {
        expect($('#row_template input').prop('disabled')).toBe(false)
      });
    });
  });

  describe('.volumes .additional-entries', function() {
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
});
