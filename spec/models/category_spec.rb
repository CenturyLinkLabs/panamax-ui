require 'spec_helper'

describe Category do

  it { should respond_to :id }
  it { should respond_to :name }
  it { should respond_to :position }
end
