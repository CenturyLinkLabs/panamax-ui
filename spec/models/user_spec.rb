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
    subject { fake_user.has_valid_github_creds? }

    context 'when all github creds are present' do
      let(:fake_user) { User.new(github_access_token_present: true, email: 'foo', github_username: 'bar') }
      it { should be_truthy }
    end

    context 'when github username is not present' do
      let(:fake_user) { User.new(github_access_token_present: true, email: 'foo', github_username: '') }
      it { should be_falsey }
    end

    context 'when only user email is not present' do
      let(:fake_user) { User.new(github_access_token_present: true, email: '', github_username: 'bar') }
      it { should be_falsey }
    end

    context 'when only github token is not present' do
      let(:fake_user) { User.new(github_access_token_present: false, email: 'foo', github_username: 'bar') }
      it { should be_falsey }
    end

    context 'when only github token is present' do
      let(:fake_user) { User.new(github_access_token_present: true, email: '', github_username: '') }
      it { should be_falsey }
    end

    context 'when only email is present' do
      let(:fake_user) { User.new(github_access_token_present: false, email: 'foo', github_username: '') }
      it { should be_falsey }
    end

    context 'when only github username is present' do
      let(:fake_user) { User.new(github_access_token_present: false, email: '', github_username: 'bar') }
      it { should be_falsey }
    end

    context 'when all github creds are not present' do
      let(:fake_user) { User.new(github_access_token_present: false, email: '', github_username: '') }
      it { should be_falsey }
    end
  end

  describe '#has_invalid_github_creds?' do
    subject { fake_user.has_invalid_github_creds? }

    context 'when all github creds are present' do
      let(:fake_user) { User.new(github_access_token_present: true, email: 'foo', github_username: 'bar') }
      it { should be_falsey }
    end

    context 'when only github token is present' do
      let(:fake_user) { User.new(github_access_token_present: true, email: nil, github_username: nil) }
      it { should be_truthy }
    end

    context 'when only github token is not present' do
      let(:fake_user) { User.new(github_access_token_present: false, email: 'foo', github_username: 'bar') }
      it { should be_falsey }
    end

    context 'when only email is not present' do
      let(:fake_user) { User.new(github_access_token_present: true, email: '', github_username: 'bar') }
      it { should be_falsey }
    end

    context 'when only github username is not present' do
      let(:fake_user) { User.new(github_access_token_present: true, email: 'foo', github_username: '') }
      it { should be_falsey }
    end

    context 'when only user name is present' do
      let(:fake_user) { User.new(github_access_token_present: false, email: '', github_username: 'bar') }
      it { should be_falsey }
    end

    context 'when only email is present' do
      let(:fake_user) { User.new(github_access_token_present: false, email: 'foo', github_username: '') }
      it { should be_falsey }
    end

    context 'when all github creds are not present' do
      let(:fake_user) { User.new(github_access_token_present: false, email: nil, github_username: nil) }
      it { should be_falsey }
    end
  end

end
