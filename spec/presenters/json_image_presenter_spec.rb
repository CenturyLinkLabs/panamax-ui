require 'spec_helper'

describe JsonImagePresenter do
  describe '#title' do
    it 'returns the handlebar template tag for repository' do
      expect(subject.title).to eq '{{source}}'
    end
  end

  describe '#short_description' do
    it 'exposes the handlebar template tag for short description' do
      expect(subject.short_description).to eq '{{short_description}}'
    end
  end

  describe '#description' do
    it 'exposes the handlebar template tag for description' do
      expect(subject.description).to eq '{{description}}'
    end
  end

  describe '#status_label' do
    it 'exposes the handlebar template tag for status label' do
      expect(subject.status_label).to eq '{{status_label}}'
    end
  end

  describe '#star_count' do
    it 'exposes the handlebar template tag for star count' do
      expect(subject.star_count).to eq '{{star_count}}'
    end
  end

  describe '#recommended_class' do
    it 'exposes the template recommended_class value' do
      expect(subject.recommended_class).to eq '{{recommended_class}}'
    end
  end

  describe '#docker_index_url' do
    it 'exposes the handlebar template tag for docker index url' do
      expect(subject.docker_index_url).to eq '{{docker_index_url}}'
    end
  end
end
