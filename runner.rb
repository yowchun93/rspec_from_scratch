def describe(description, &block)
  puts description
  block.call
end

def expect(actual=nil, &block)
  Actual.new(actual || block)
end

def eq(expected)
  Expectations::Equal.new(expected)
end

def raise_error(exception_class)
  Expectations::Error.new(exception_class)
end

class Actual
  def initialize(actual)
    @actual = actual
  end

  def to(expectation)
    expectation.run(@actual)
  end
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
    puts " #{RED}(fail)#{RESET}"
    puts [
      "#{RED}* Backtrace: #{RESET}",
      e.backtrace.reverse.map { |line| "#{RED}|#{RESET} #{line}" },
      "#{RED}* #{e} #{RESET}",
    ].flatten.map { |line| "\t#{line}" }.join("\n")
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

class Expectations
  class Equal
    def initialize(expected)
      @expected = expected
    end

    def run(actual)
      unless actual == @expected
        raise AssertionError.new(
          "Expected #{@expected.inspect} but got #{@actual.inspect}")
      end
    end
  end

  class Error
    def initialize(exception_class)
      @exception_class = exception_class
    end

    def run(actual_block)
      begin
        actual_block.call
      rescue @exception_class
        return
      rescue StandardError => e
        raise AssertionError.new(
          format('Expected to see error %s, but saw %s',
            @exception_class.inspect,
            e.inspect))
      end
      raise AssertionError.new(
        format("Expected to see error %s, but got nothing",
          @exception_class.inspect))
    end
  end
end

class AssertionError < RuntimeError

end