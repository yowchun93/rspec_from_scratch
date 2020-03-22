require_relative 'runner'

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
  let(:random) { rand }

  it 'is available inside the test' do
    expect(five).to eq(5)
  end

  it 'always returns the same object' do
    expect(random).to eq random
  end

  it "still fails when method don't exist" do
    expect do
      method_that_dont_exist
    end.to raise_error(NameError)
  end
end