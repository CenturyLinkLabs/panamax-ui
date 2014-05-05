shared_examples "a view model" do |attributes|

  describe 'attribute readers' do
    subject { described_class.new(attributes) }

    attributes.each do |name, value|
      describe "##{name}" do
        it "exposes #{name}" do
          expect(subject.send(name)).to eq value
        end
      end
    end
  end

  describe 'comparison' do
    let(:thing_1) { described_class.new(attributes) }
    let(:thing_2) { described_class.new(attributes) }
    let(:not_a_thing) { double(:not_a_thing, {to_hash: {go: 'away'}}) }

    describe '#eql?' do
      it 'compares value equality' do
        expect(thing_1.eql?(thing_2)).to be_true
      end

      context 'comparing with a non thing' do
        it 'fails value equality' do
          expect(thing_1.eql?(not_a_thing)).to be_false
        end
      end
    end

    describe '#==' do
      it 'compares value equality' do
        expect(thing_1 == thing_2).to be_true
      end

      context 'comparing with a non thing' do
        it 'fails value equality' do
          expect(thing_1 == not_a_thing).to be_false
        end
      end
    end

    describe '#equal?' do
      it 'compares on object identity' do
        expect(thing_1.equal?(thing_1)).to be_true
      end

      context 'with a different instance' do
        it 'fails object identity comparison' do
          expect(thing_1.equal?(thing_2)).to be_false
        end
      end
    end
  end
end
