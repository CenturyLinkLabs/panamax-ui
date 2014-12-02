describe('$.PMX.NewRemoteDeployment', function() {
  var subject;
  var refreshPromise;

  beforeEach(function() {
    refreshPromise = $.Deferred();
    spyOn($.PMX, 'DeploymentTargetRefresh').andReturn(refreshPromise.promise());
    fixture.load('deployment_settings.html');
    subject = new $.PMX.NewRemoteDeployment(
      $('.deployment-settings'),
      { refreshPath: '/refresh_path.html' }
    );
    subject.init();
  });

  it('calls DeploymentTargetRefresh with the passed-in refreshPath', function() {
    expect($.PMX.DeploymentTargetRefresh).toHaveBeenCalledWith("/refresh_path.html");
  });

  describe('before DeploymentTargetRefresh resolves', function() {
    it('disbles the submit button', function() {
      expect($("button.deploy").prop("disabled")).toBe(true);
    });
  });

  describe('after DeploymentTargetRefresh resolves successfully', function() {
    beforeEach(function() { refreshPromise.resolve(); });

    it('enables the button', function() {
      expect($("button.deploy").prop("disabled")).toBe(false);
    });
  });

  describe('after DeploymentTargetRefresh rejects', function() {
    beforeEach(function() {
      refreshPromise.reject({
        message: "Test Error Message!",
        fixPath: "/fix.html"
      });
    });

    it('keeps the button disabled', function() {
      expect($("button.deploy").prop("disabled")).toBe(true);
    });

    it('shows a warning', function() {
      var notice = $(".deployment-settings > section.notice");
      expect(notice.length).toEqual(1);
      expect(notice.find(".notice-warning").text()).toContain("Test Error Message!");
    });
  });
});
