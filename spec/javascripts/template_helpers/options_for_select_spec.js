describe('optionsForSelect', function() {
  var subject;

  beforeEach(function() {
    subject = Handlebars.helpers.optionsForSelect;
  });

  it('renders <option> tags for each item in the provided array', function() {
    result = subject(['foo', 'bar']);
    expect(result).toBe(
      '<option value="foo">foo</option><option value="bar">bar</option>');
  });
});
