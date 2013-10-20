require 'spec_helper'

describe Ai do
  let(:user) { FactoryGirl.create(:user) }
  before do
    # This code is not idiomatically correct.
    # @ai =Ai.new(name: "Super IA", user_id: user.id)
    @ai = user.ais.build(name: "Super IA")

  end

  subject { @ai }

  it { should respond_to(:name) }
  it { should respond_to(:user_id) }
  it { should respond_to(:active) }
  it { should respond_to(:elo) }
  it { should respond_to(:version) }
  it { should respond_to(:user) }
  its(:user) { should eq user }
end
