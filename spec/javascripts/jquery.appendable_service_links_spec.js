describe('$.fn.appendableServiceLinks', function() {
  var subject;

  beforeEach(function() {
    fixture.load('appendable.html');
  });

  beforeEach(function() {
    spyOn($.PMX.Helpers, 'guid').andReturn('abcuidxyz');
    $('#row_template select').prop('disabled', true);
    var fakeAdditonalItem = {
      $el: $('#row_template')
    }
    spyOn($.fn, 'appendable').andCallFake(function(options) {
      options.addCallback.call(this, fakeAdditonalItem);
    });
    spyOn($.fn, 'chosen');
    subject = new $.PMX.AppendableServiceLinks($('ol'));
    subject.init();
  });

  it('calls the appendable plugin with the proper arguments', function() {
    var args = subject.$el.appendable.mostRecentCall.args[0];
    expect(subject.$el.appendable).toHaveBeenCalled();
    expect(args.$trigger.selector).toEqual('ol .button-add');
    expect(args.$elementToAppend.selector).toEqual('ol .additional-entries li:first-of-type');
    expect(args.addCallback).toEqual(jasmine.any(Function));
  });

  it('replaces the _replaceme_ value in the inputs', function() {
    expect($('#row_template select').attr('name')).toEqual('[link]abcuidxyz');
  });

  it('re-enables disabled fields', function() {
    expect($('#row_template select').prop('disabled')).toBe(false);
  });

  it('updates the alias input to match the value from the select', function() {
    expect($('#row_template input#alias_input').val()).toEqual('bar');
  });

  it('instantiates chosen on the selects', function() {
    expect($.fn.chosen).toHaveBeenCalledWith({disable_search: true});
  });
});
