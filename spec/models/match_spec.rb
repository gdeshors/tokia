require 'spec_helper'

describe Match do
  let(:user1) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user) }
  before do
    # This code is not idiomatically correct.
    @ai1 = Ai.new(name: "Super IA", user: user1)
    @ai2 = Ai.new(name: "Super IA2", user: user2)
    @match = Match.new(winner1: @ai1, winner2: @ai1, winner: @ai1, ai_1: @ai1, ai_2: @ai2)
    @match.save
  end
  
  subject { @match }

  it { should respond_to(:winner) }
  it { should respond_to(:winner1) }
  it { should respond_to(:winner2) }
  it { should respond_to(:ai_1_id) }
  it { should respond_to(:ai_2_id) }
  it { should respond_to(:ai_1) }
  it { should respond_to(:ai_2) }
  it { should respond_to(:log1) }
  it { should respond_to(:log2) }
  it { should respond_to(:created_at) }

  describe "when there is one match" do

    describe "ais should have one match" do
      specify { expect(@ai1.matches.size).to eq 1 }
      specify { expect(@ai2.matches.size).to eq 1 }
    end
    describe "matches should be the same for both" do
      specify { expect(@ai1.matches.to_a).to eq @ai2.matches.to_a }
    end

  end

end
