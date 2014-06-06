describe('$.fn.searchQueryPopulator', function() {
  beforeEach(function() {
    spyOn($.fn, 'submit');
    fixture.load('search.html');
    $('.example-searches').searchQueryPopulator({
      $searchField: $('input.query-field')
    });
  });

  it('populates the search box with the clicked term', function() {
    $('a[data-query="apache"]').click();
    expect($('input.query-field').val()).toEqual('apache');
  });

  it('gives the search box focus after clicking a term', function() {
    var focusSpy = spyOn($.fn, 'focus');
    $('a[data-query="apache"]').click();
    expect(focusSpy).toHaveBeenCalled();
    // unfortanetely the below assertion does not work headlessly
    // expect($('input.query-field').is(':focus')).toBeTruthy();
  });

  it('re-populates the search box with the next clicked term', function() {
    $('input.query-field').val('old term')
    $('a[data-query="java"]').click();
    expect($('input.query-field').val()).toEqual('java');
  });

  it('submits the search form', function() {
    $('a[data-query="java"]').click();
    expect($.fn.submit).toHaveBeenCalled();
  });

  it('hides the example section', function() {
    expect($('.example-searches').css('display')).toEqual('block');
    $('a[data-query="java"]').click();
    expect($('.example-searches').css('display')).toEqual('none');
  });
});
