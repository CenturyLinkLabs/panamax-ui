require 'spec_helper'

describe Link do

  it { should respond_to :service_id }
  it { should respond_to :service_name }
  it { should respond_to :alias }
end
