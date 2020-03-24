require_relative 'runner'

describe "describe" do
  describe "nested desribe" do
    it "should still run tests" do
      expect(1 + 1).to eq(2)
    end
  end
end

describe "it" do
  it "should not allow its inside other its" do
    expect do
      it "should not work" do
      end
    end.to raise_error(NameError)
  end
end

describe "expectations" do
  it "can expect values" do
    expect(1 + 1).to eq(2)
  end

  it "can expect exceptions" do
    expect do
      raise ArgumentError.new
    end.to raise_error(ArgumentError)
  end
end

describe "let" do
  let(:five) { 5 }
  let(:six) { five + 1 }
  let(:random) { rand }

  it 'is available inside the test' do
    # uses method_missing
    expect(five).to eq(5)
  end

  it 'always returns the same object' do
    # uses method_missing
    expect(random).to eq random
  end

  it "still fails when method don't exist" do
    expect do
      method_that_dont_exist
    end.to raise_error(NameError)
  end

  it "can reference other lets" do
    expect(six).to eq(6)
  end

  describe "nested describes" do
    let(:sibling_five) { 5 }
    it "can see lets from the parent describe" do
      expect(five).to eq(5)
    end
  end

  describe "subling describes" do
    it "can't see its sibling's lets" do
      expect do
        sibling_five
      end.to raise_error(NameError)
    end
  end
end

describe "before" do
  before { @five = 5 }
  before { @six = @five + 1 }

  it "should be visible inside the test" do
    expect(@five).to eq 5
  end

  it "can reference values set up by other befores" do
    expect(@six).to eq 6
  end
end

describe "let and before interacting" do
  let(:five) { 5 }
  before { @six = five + 1 }
  let(:seven) { @six + 1 }

  it "allows before to reference lets" do
    expect(@six).to eq(6)
  end

  it "allows lets to reference before" do
    expect(seven).to eq(7)
  end
end

# assertions (expectations)
# describe + describe  untested OK
# it + it   untested BUG
# let + let untested OK
# before    untested OK
#
# describe + it
# describe + let
# describe + before
#
# it + it
# it + before
#
# let + before