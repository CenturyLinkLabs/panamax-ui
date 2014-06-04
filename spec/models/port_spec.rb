require 'spec_helper'

describe Port do

  it { should respond_to :host_interface }
  it { should respond_to :host_port }
  it { should respond_to :container_port }
  it { should respond_to :proto }
end
