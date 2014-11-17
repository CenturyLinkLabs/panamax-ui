require 'spec_helper'

describe DeploymentTargetMetadataRefreshesController do
  describe '#create' do
    subject { response }
    let(:format) { :html }
    let(:post_create) { post :create, deployment_target_id: '19', format: format }
    before { DeploymentTargetMetadataRefresh.stub(:create).and_call_original }

    context 'when refresh is successful' do
      before { post_create }

      it 'creates a DeploymentTargetMetadataRefresh with the expected DeploymentTarget' do
        expect(DeploymentTargetMetadataRefresh).to(
          have_received(:create)
          .with(deployment_target_id: '19')
        )
      end

      context 'HTML format' do
        it 'sets a flash success message' do
          expect(flash[:success]).to eq(I18n.t('deployment_targets.metadata_refresh.success'))
        end

        it { should redirect_to(deployment_targets_path) }
      end

      context 'JSON format' do
        let(:format) { :json }

        its(:status) { should eq(201) }

        it 'does not set a flash message' do
          expect(flash[:success]).to be_nil
        end

        describe 'the JSON response' do
          subject(:hash) { JSON.parse(response.body) }
          its(:keys) { should include('agent_version', 'adapter_type') }
        end
      end
    end

    context 'when refresh fails' do
      before do
        DeploymentTargetMetadataRefresh.stub(:create).and_raise(error)
        post_create
      end

      context 'due to ActiveResource::ServerError' do
        let(:error) { ActiveResource::ServerError.new('Troubles') }

        context 'HTML format' do
          it { should redirect_to(deployment_targets_path) }

          it 'sets a flash alert message' do
            expect(flash[:alert]).to eq(I18n.t('deployment_targets.metadata_refresh.failure'))
          end
        end

        context 'JSON format' do
          let(:format) { :json }

          it 'does not set a flash message' do
            expect(flash[:alert]).to be_nil
          end

          its(:status) { should eq(409) }
          its(:headers) { should include('Location' => deployment_targets_path) }

          describe 'the JSON response' do
            subject { JSON.parse(response.body) }
            its(['error']) { should eq(I18n.t('deployment_targets.metadata_refresh.failure')) }
          end
        end
      end
    end
  end
end
