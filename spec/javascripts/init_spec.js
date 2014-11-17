describe('$.PMX.init', function() {
  var subject = $.PMX.ogInit;

  beforeEach(function() {
    spyOn(Handlebars, 'compile');
    spyOn($.PMX, 'ErrorInterceptor').andCallFake(function($el, options) {
      return {
        init: function() {},
        handleError: function() {}
      }
    });
  });

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

        subject();
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
        subject();
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
        fixture.load('appendable_volumes.html');
      });

      beforeEach(function() {
        $('#row_template input').prop('disabled', true);
        var fakeAdditonalItem = {
          $el: $('#row_template')
        };

        spyOn($.PMX, 'Appendable').andCallFake(function($el, options) {
          return {
            init: function() {
              options.addCallback.call(this, fakeAdditonalItem);
            }
          }
        });
        subject();
      });

      it('calls the appendable plugin with the appropriate base element', function() {
        var nativeDomEl = $.PMX.Appendable.mostRecentCall.args[0][0];
        expect(nativeDomEl.length).toBe();
        expect(nativeDomEl).toEqual($('.volumes .additional-entries')[0]);
      });

      it('calls the appendable plugin with the appropriate trigger', function() {
        var nativeDomEl = $.PMX.Appendable.mostRecentCall.args[1].$trigger[0];
        expect(nativeDomEl.length).toBe();
        expect(nativeDomEl).toEqual($('.volumes .button-add')[0]);
      });

      it('calls the appendable plugin with the appropriate elementToAppend', function() {
        var elToAppend = $.PMX.Appendable.mostRecentCall.args[1].$elementToAppend;
        expect(elToAppend.html()).toEqual('/foo/bar');
      });

      it('replaces the _replaceme_ value in the inputs', function() {
        expect($('#row_template input').attr('name')).not.toMatch('replaceme');
      });

      it('re-enables disabled fields', function() {
        expect($('#row_template input').prop('disabled')).toBe(false)
      });
    });
  });

  describe("$.fn.newRemoteDeployment", function() {
    beforeEach(function() {
      fixture.load('deployment_settings.html');
      spyOn($.PMX, 'NewRemoteDeployment').andCallFake(function() {
        return { init: function() {} };
      });
      subject();
    });

    it('calls the NewRemoteDeployment plugin with the correct base element', function() {
      var nativeDomEl = $.PMX.NewRemoteDeployment.mostRecentCall.args[0][0];
      expect(nativeDomEl.length).toBe();
      expect(nativeDomEl).toEqual($('.deployment-settings')[0]);
    });

    it('calls the NewRemoteDeployment with the correct refreshPath', function() {
      var refreshPath = $.PMX.NewRemoteDeployment.mostRecentCall.args[1].refreshPath;
      expect(refreshPath).toEqual("/refresh_path.html");
    });
  });
});
