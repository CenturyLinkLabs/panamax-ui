require 'spec_helper'

describe User do
  it 'sets the singleton name to the model_name.element' do
    expect(described_class.singleton_name).to eq 'user'
  end

  it { should respond_to :email }
  it { should respond_to :github_access_token_present }
  it { should respond_to :github_username }
  it { should respond_to :subscribe }

  describe '#repositories' do
    it 'should always respond to each' do
      expect(subject.repositories).to respond_to :each
    end
  end

  describe '#github_access_token' do
    it 'exists to satisfy form_for, but always returns nil' do
      expect(subject.github_access_token).to be_nil
    end
  end

  describe '#has_valid_github_creds?' do
    context 'when all github creds are valid' do
      let(:fake_user) { User.new(github_access_token_present: true, email: 'foo', github_username: 'bar') }
      it 'returns true' do
        expect(fake_user.has_valid_github_creds?).to be_true
      end
    end

    context 'when github access token is not valid' do
      let(:fake_user) { User.new(github_access_token_present: false, email: 'foo', github_username: 'bar') }
      it 'returns false' do
        expect(fake_user.has_valid_github_creds?).to be_false
      end
    end

    context 'when user email is not valid' do
      let(:fake_user) { User.new(github_access_token_present: true, email: '', github_username: 'bar') }
      it 'returns false' do
        expect(fake_user.has_valid_github_creds?).to be_false
      end
    end

    context 'when github username is not valid' do
      let(:fake_user) { User.new(github_access_token_present: true, email: 'foo', github_username: '') }
      it 'returns false' do
        expect(fake_user.has_valid_github_creds?).to be_false
      end
    end

  end
end
