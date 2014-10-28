describe('$.fn.templateRepoActions', function () {
  var subject;

  beforeEach(function () {
    fixture.load('manage-template-repos.html');
    subject = new $.PMX.ManageTemplateRepos($('.template-repos'));
    subject.init();
    jasmine.Ajax.useMock();
  });

  describe('clicking add source button', function() {
    it ('shows the form if the form is hidden', function () {
      var click = new $.Event('click');
      $('.button-add').trigger(click);
      expect($('form').css('display')).toEqual('block');
    });

    it ('hides the form if the form is visible', function () {
      var click = new $.Event('click');
      $('form').css('display', 'block');
      $('.button-add').trigger(click);
      expect($('form').css('display')).toEqual('none');
    });
  });
});
