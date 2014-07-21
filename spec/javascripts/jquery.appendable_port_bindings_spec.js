describe('$.fn.appendablePortBindings', function() {
  var subject;

  beforeEach(function() {
    fixture.load('appendable-port-bindings.html');
  });

  beforeEach(function() {
    spyOn($.PMX.Helpers, 'guid').andReturn('abcuid');
    $('#port_binding select').prop('disabled', true);
    var fakeAdditonalItem = {
      $el: $('#row_template')
    }
    spyOn($.fn, 'appendable').andCallFake(function(options) {
      options.addCallback.call(this, fakeAdditonalItem);
    });
    spyOn($.fn, 'chosen');
    subject = new $.PMX.AppendablePortBindings($('ol'));
    subject.init();
  });

  it('calls the appendable plugin with the proper arguments', function() {
    var args = subject.$el.appendable.mostRecentCall.args[0];
    expect(subject.$el.appendable).toHaveBeenCalled();
    expect(args.$trigger.selector).toEqual('ol .button-add');
    expect(args.$elementToAppend.selector).toEqual('ol .additional-entries li:first-of-type');
    expect(args.addCallback).toEqual(jasmine.any(Function));
  });

  it('instantiates chosen on the selects', function() {
    expect($.fn.chosen).toHaveBeenCalledWith({disable_search: true});
  });

  it('replaces the _replaceme_ value on the fields', function() {
    expect($('#row_template input').attr('name')).toEqual('[host]abcuid');
    expect($('#row_template select').attr('name')).toEqual('[proto]abcuid');
  });

  it('re-enables disabled fields', function() {
    expect($('#row_template input').prop('disabled')).toBe(false)
    expect($('#row_template select').prop('disabled')).toBe(false)
  });
});
