shared_examples 'an image' do

  describe '#short_description' do
    before do
      subject.description = 'w' * 300
    end

    it 'truncates the description to 165 charectors' do
      expect(subject.short_description).to eq 'w' * 162 + '...'
    end
  end

  describe '#official?' do
    it 'is a proxy to is_official' do
      subject.is_trusted = true
      expect(subject.trusted?).to eq true
      subject.is_trusted = false
      expect(subject.trusted?).to eq false
    end
  end

  describe '#trusted?' do
    it 'is a proxy to is_trusted' do
      subject.is_trusted = true
      expect(subject.trusted?).to eq true
      subject.is_trusted = false
      expect(subject.trusted?).to eq false
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

    context 'when both trusted and official are set' do
      before do
        subject.is_trusted = true
        subject.is_official = true
      end

      it 'is official if both the trusted and official flags are set' do
        expect(subject.status_label).to eql 'Official'
      end
    end
  end

end
