def describe(description, &block)
  puts description
  block.call
end

GREEN = "\e[32m"
RED   = "\e[31m"
RESET = "\e[0m"

def it(description, &block)
  begin
    $stdout.write " - #{description}"
    block.call
    puts " #{GREEN}(ok)#{RESET}"
  rescue Exception => e
    puts " #{RED}(ok)#{RESET}"
  end
end

class Object
  def should
    ComparisonAssertion.new(self)
  end
end

class ComparisonAssertion
  def initialize(actual)
    @actual = actual
  end

  def ==(expected)
    unless @actual == expected
      raise AssertionError.new(
        "Expected #{expected.inspect} but got #{@actual.inspect}")
    end
  end
end

class AssertionError < RuntimeError

end