require 'spec_helper'

describe NoticesHelper do
  describe '#notification_class' do
    it 'returns the CSS class for the flash key' do
      expect(notification_class('success')).to eq 'notice-success'
      expect(notification_class('notice')).to eq 'notice-default'
      expect(notification_class('warning')).to eq 'notice-success'
      expect(notification_class('alert')).to eq 'notice-danger'
    end

    it 'returns notice-default for unexpected flash keys' do
      expect(notification_class('wonky')).to eq 'notice-default'
    end
  end
end
