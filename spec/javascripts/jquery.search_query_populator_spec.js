describe('$.fn.searchQueryPopulator', function() {
  beforeEach(function() {
    spyOn($.fn, 'submit');
    fixture.load('search.html');
    $('.example-searches').searchQueryPopulator({
      $searchField: $('input#search_form_query')
    });
  });

  it('populates the search box with the clicked term', function() {
    $('a[data-query="apache"]').click();
    expect($('input#search_form_query').val()).toEqual('apache');
  });

  it('gives the search box focus after clicking a term', function() {
    var focusSpy = spyOn($.fn, 'focus');
    $('a[data-query="apache"]').click();
    expect(focusSpy).toHaveBeenCalled();
    // unfortanetely the below assertion does not work headlessly
    // expect($('input#search_form_query').is(':focus')).toBeTruthy();
  });

  it('re-populates the search box with the next clicked term', function() {
    $('input#search_form_query').val('old term')
    $('a[data-query="java"]').click();
    expect($('input#search_form_query').val()).toEqual('java');
  });

  it('submits the search form', function() {
    $('a[data-query="java"]').click();
    expect($.fn.submit).toHaveBeenCalled();
  });
});
