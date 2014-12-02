describe('$.PMX.DeploymentTargetRefresh', function() {
  var subject;

  beforeEach(function() {
    jasmine.Ajax.useMock();
    clearAjaxRequests();
    subject = $.PMX.DeploymentTargetRefresh("/refresh.html");
  });

  it('makes an AJAX POST to the passed-in URL', function() {
    expect(ajaxRequests.length).toEqual(1);
    var request = ajaxRequests[0];
    expect(request.url).toEqual("/refresh.html");
    expect(request.method).toEqual("POST");
  });

  describe("when AJAX responds", function() {
    var callbackCalled;
    beforeEach(function() { callbackCalled = false });

    describe('when the AJAX call returns a 201', function() {
      var respondWithSuccess = function() {
        ajaxRequests[0].response({
          status: 201,
          responseText: JSON.stringify({ key: 'value'})
        });
      };

      it('resolves with the parsed JSON', function() {
        subject.done(function(o) {
          callbackCalled = true;
          expect(o).toEqual({ key: 'value' });
        });
        respondWithSuccess();
        expect(callbackCalled).toBe(true);
      });

      it('does not reject', function() {
        subject.fail(function() { callbackCalled = true; });
        respondWithSuccess();
        expect(callbackCalled).toBe(false);
      });
    });

    describe('when the AJAX returns a 409', function() {
      var respondWithError = function() {
        ajaxRequests[0].response({
          status: 409,
          responseText: JSON.stringify({ error: 'Test Error Message!'}),
          // Have to specify Content-Type because setting responseHeaders
          // overrides the mock-ajax defaults.
          responseHeaders: { "Location": "example.com", "Content-Type": "application/json" }
        });
      };

      it('rejects with the expected attributes', function() {
        subject.fail(function(o) {
          callbackCalled = true;
          expect(o.message).toEqual("Test Error Message!");
          expect(o.fixPath).toEqual("example.com");
        });
        respondWithError();
        expect(callbackCalled).toBe(true);
      });

      it('does not resolve', function() {
        subject.done(function() { callbackCalled = true; });
        respondWithError();
        expect(callbackCalled).toBe(false);
      });
    });
  });
});
