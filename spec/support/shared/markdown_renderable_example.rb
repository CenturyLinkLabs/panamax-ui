shared_examples 'a markdown renderable object' do
  describe '#documentation_to_html' do
    let(:documentation) { 'just run rake' }

    it 'returns a new kramdown html document when documentation exists' do
      as_html = '<p>run rake</p>'
      subject.documentation = documentation
      fake_krammy = double(:fake_kramdown_object, to_html: as_html)
      expect(Kramdown::Document).to receive(:new).with(documentation).and_return(fake_krammy)

      expect(subject.documentation_to_html).to eq as_html
    end

    it 'returns an empty string if documentation does not exist' do
      expect(subject.documentation_to_html).to eq ''
    end
  end
end
