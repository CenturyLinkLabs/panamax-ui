shared_examples 'an image' do

  describe '#short_description' do
    before do
      subject.description = 'w' * 300
    end

    it 'truncates the description to 165 charectors' do
      expect(subject.short_description).to eq 'w' * 162 + '...'
    end
  end

  describe '#recommended_class' do
    it 'is not-recommended' do
      expect(subject.recommended_class).to eq 'not-recommended'
    end

    context 'when recommended' do
      before do
        subject.recommended = true
      end

      it 'is recommended' do
        expect(subject.recommended_class).to eq 'recommended'
      end
    end
  end

  describe '#status_label' do
    context 'when the trusted flag is set' do
      before do
        subject.is_trusted = true
      end

      it 'is trusted' do
        expect(subject.status_label).to eql 'Trusted'
      end
    end

    context 'when both trusted and recommended are set' do
      before do
        subject.is_trusted = true
        subject.recommended = true
      end

      it 'is recommended if both the trusted and recommended flags are set' do
        expect(subject.status_label).to eql 'Recommended'
      end
    end
  end

end
