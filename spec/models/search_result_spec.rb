require 'spec_helper'

describe SearchResultSet do

  it { should respond_to :q }
  it { should respond_to :remote_images }
  it { should respond_to :local_images }
  it { should respond_to :templates }


end
