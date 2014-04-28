require 'spec_helper'

describe BreadcrumbHelper do
  describe '#breadcrumbs_for' do
    it 'accumulates the crumbs that are passed in' do
      result = breadcrumbs_for(1,2,3)
      expect(result).to eql [1,2,3]
    end

    it 'truncates the second to last item if the crumbs are too long' do
      result = breadcrumbs_for(
        'First',
        'Second with a bunch of text that we do not need',
        'Last'
      )
      expect(result.join('/').length).to eq 46
      expect(result.join('/')).to eq 'First/Second with a bunch of text that.../Last'
    end

    context 'when some items are links' do
      it 'truncates the second to last item' do
        result = breadcrumbs_for(
          'First',
          link_to('Second with a bunch of text that we do not need', '#'),
          'Last'
        )
        expect(result.join('/')).to eq 'First/<a href="#">Second with a bunch of text that...</a>/Last'
      end
    end
  end
end
