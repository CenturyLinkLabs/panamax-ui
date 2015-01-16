require 'spec_helper'

describe JobTemplate do
  it_behaves_like 'an active resource model'

  it { should respond_to :environment }
  it { should respond_to :name }
end
