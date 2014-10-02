describe('$.fn.appendableVolumesFrom', function() {
  var subject;

  beforeEach(function() {
    fixture.load('appendable-volumes-from.html');
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
    subject = new $.PMX.AppendableVolumesFrom($('ol'));
  });

  it('calls the appendable plugin with the proper arguments', function() {
    subject.init();
    var args = subject.$el.appendable.mostRecentCall.args[0];
    expect(subject.$el.appendable).toHaveBeenCalled();
    expect(args.$trigger.selector).toEqual('ol .button-add');
    expect(args.$elementToAppend.selector).toEqual('ol .additional-entries li:first-of-type');
    expect(args.addCallback).toEqual(jasmine.any(Function));
  });

  it('replaces the _replaceme_ value in the inputs', function() {
    expect($('#row_template select').attr('name')).toEqual('[volumes_from]_replaceme_');
    subject.init();
    expect($('#row_template select').attr('name')).toEqual('[volumes_from]abcuidxyz');
  });

  it('re-enables disabled fields', function() {
    expect($('#row_template select').prop('disabled')).toBe(true);
    subject.init();
    expect($('#row_template select').prop('disabled')).toBe(false);
  });

  it('instantiates chosen on the selects', function() {
    subject.init();
    expect($.fn.chosen).toHaveBeenCalledWith({disable_search: true});
  });
});
