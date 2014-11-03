require 'spec_helper'

describe Override do

  it_behaves_like 'an active resource model'

  it { should respond_to :id }
  it { should respond_to :images }

end
