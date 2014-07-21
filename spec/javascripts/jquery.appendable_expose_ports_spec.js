describe('$.fn.appendableExposePorts', function() {
  var subject;

  beforeEach(function() {
    fixture.load('appendable-exposed-ports.html');
  });

  beforeEach(function() {
    spyOn($.PMX.Helpers, 'guid').andReturn('abcuid123');
    $('#row_template select').prop('disabled', true);
    var fakeAdditonalItem = {
      $el: $('#row_template')
    }
    spyOn($.fn, 'appendable').andCallFake(function(options) {
      options.addCallback.call(this, fakeAdditonalItem);
    });
    subject = new $.PMX.AppendableExposePorts($('ol'));
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
    expect($('#row_template input').attr('name')).toEqual('[port]abcuid123');
  });

  it('re-enables disabled fields', function() {
    expect($('#row_template input').prop('disabled')).toBe(false);
  });
});
