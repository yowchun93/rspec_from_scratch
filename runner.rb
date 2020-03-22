GREEN = "\e[32m"
RED   = "\e[31m"
RESET = "\e[0m"

def describe(description, &block)
  Describe.new(description, block).run
end

class Describe
  def initialize(description, block)
    @description = description
    @block = block
    @lets = {}
    @befores = []
  end

  # instance_eval, runs the block in context of describe object
  # instance_eval is mainly used to run blocks
  def run
    puts @description
    # @block.call
    instance_eval(&@block) # check out why this works
  end

  def it(description, &block)
    It.new(description, block, @lets, @befores).run
  end

  def let(name, &block)
    @lets[name] = block
  end

  def before(&block)
    @befores << block
  end
end

class It
  def initialize(description, block, lets, befores)
    @description = description
    @block = block
    @lets = lets
    @lets_cache = {}
    @befores = befores
  end

  def run
    begin
      $stdout.write " - #{@description}"
      # @block.call
      @befores.each { |block| instance_eval(&block) }
      instance_eval(&@block)
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

  def expect(actual=nil, &block)
    Actual.new(actual || block)
  end

  def eq(expected)
    Expectations::Equal.new(expected)
  end

  def raise_error(exception_class)
    Expectations::Error.new(exception_class)
  end

  def method_missing(name)
    if @lets_cache.key?(name)
      @lets_cache.fetch(name)
    else
      value = instance_eval(&@lets.fetch(name) { super })
      @lets_cache[name] = value
      value
    end
  end
end

class Actual
  def initialize(actual)
    @actual = actual
  end

  def to(expectation)
    expectation.run(@actual)
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