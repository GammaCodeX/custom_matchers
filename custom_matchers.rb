require 'rspec'

def eventually(matcher)
  @eventually ||= Eventually.new(matcher)
end

class Eventually
  def initialize(matcher)
    @matcher = matcher
  end

  def matches?(block)
    5.times do # Replace this with a call to :run_until_success to get same behaviour as the rest of our DSL
      @result = block.call
      return true if @matcher.matches? @result
    end
    false
  end

  def supports_block_expectations?
    true
  end

  def failure_message
    "expected to eventually #{@matcher.description}, but last result was #{@result.inspect}"
  end
end
