require 'spec_helper'

describe TemplateCopyForm do
  let(:fake_template) do
    double(:fake_template,
           id: 7,
           images: [1, 2],
           attributes: { id: 7, images: [1, 2] }
          )
  end

  subject { described_class.new(original_template: fake_template) }

  describe '#template_id' do
    it 'exposes the original template id' do
      expect(subject.template_id).to eq 7
    end
  end

  describe '#images' do
    it 'exposes the original templates images' do
      expect(subject.images).to eq [1, 2]
    end
  end

  describe '#images_attributes' do
    it { should respond_to :images_attributes= }
  end

  describe '#create_new_template' do

    let(:img_1_id) { 22 }
    let(:img_2_id) { 23 }
    let(:fake_img_1) { double(:fake_img_1, id: img_1_id, :environment_attributes= => nil, :id= => nil) }
    let(:fake_img_2) { double(:fake_img_1, id: img_2_id, :environment_attributes= => nil, :id= => nil) }
    let(:fake_new_template) { double(:fake_new_template, images: [fake_img_1, fake_img_2], save: true) }
    let(:img_1_env) do
      {
        '0' => {
          'variable' => 'BOO', 'value' => 'yah', 'id' => ''
        },
        '1' => {
          'variable' => 'GIT_REPO', 'value' => 'bla.git', 'id' => ''
        }
      }
    end
    let(:img_2_env) do
      {
        '0' => {
          'variable' => 'GIT_REPO', 'value' => 'foo.git', 'id' => ''
        }
      }
    end
    let(:img_attrs) do
      {
        '0' => {
          'environment_attributes' => img_1_env,
          'id' => img_1_id.to_s
        },
        '1' => {
          'environment_attributes' => img_2_env,
          'id' => img_2_id.to_s
        }
      }
    end

    before do
      Template.stub(:new).with(fake_template.attributes).and_return(fake_new_template)
      subject.images_attributes = img_attrs
    end

    it 'duplicates the original template' do
      expect(Template).to receive(:new).with(fake_template.attributes)
      subject.create_new_template
    end

    it 'replaces the environment variables with the new ones' do
      expect(fake_img_1).to receive(:environment_attributes=).with(img_1_env)
      expect(fake_img_2).to receive(:environment_attributes=).with(img_2_env)
      subject.create_new_template
    end

    it 'nils out the id' do
      expect(fake_img_1).to receive(:id=).with(nil)
      expect(fake_img_2).to receive(:id=).with(nil)
      subject.create_new_template
    end

    it 'returns the new template' do
      expect(subject.create_new_template).to eq fake_new_template
    end
  end

end
