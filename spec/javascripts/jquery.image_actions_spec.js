describe('$.fn.imageActions', function() {
  var subject;

  beforeEach(function() {
    fixture.load('images.html');
    subject = new $.PMX.WatchImageSelections($('#images_flow section.image'));
    subject.init();
  });

  describe('clicking "Select All" ', function() {
    describe('when not checked', function() {
      it('check all of the delete image checkboxes', function() {
        var selectAll = $('input#all');
        selectAll.prop('checked', false);

        selectAll.click();
        expect($('.images input[type=checkbox]').filter(':checked').length).toEqual(1);
      });

      it('enables the submit button', function() {
        var selectAll = $('input#all');
        selectAll.prop('checked', false);

        selectAll.click();
        expect($('button[type=submit]').prop('disabled')).toBeFalsy();
      });
    });

    describe('when checked', function() {
      it('uncheck all of the delete image checkboxes', function() {
        var selectAll = $('input#all'),
            allBoxes = $('.images input[type=checkbox]');

        selectAll.prop('checked', true);
        allBoxes.prop('checked', true);

        selectAll.click();
        expect($('.images input[type=checkbox]').filter(':checked').length).toEqual(0);
      });

      it('disables the submit button', function() {
        var selectAll = $('input#all');
        selectAll.prop('checked', true);

        selectAll.click();
        expect($('button[type=submit]').first().prop('disabled')).toBeTruthy();
      });
    });
  });

  describe('clicking an image checkbox', function() {
    describe('when not checked', function() {
      it('enables the submit button', function() {
        var checkbox = $('.images input[type=checkbox]').first(),
            submitButton = $('button[type=submit]');

        checkbox.prop('checked', false);

        checkbox.click();
        expect(submitButton.prop('disabled')).toBeFalsy()
      });
    });

    describe('when checked', function() {
      it('disables the submit button', function() {
        var checkbox = $('.images input[type=checkbox]').first(),
          submitButton = $('button[type=submit]');

        checkbox.prop('checked', true);

        checkbox.click();
        expect(submitButton.prop('disabled')).toBeTruthy()
      });
    });
  });
});
