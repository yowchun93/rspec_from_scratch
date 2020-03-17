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
