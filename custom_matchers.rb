require 'rspec'
require 'timeout'
class Eventually
  def initialize(matcher, timeout:)
    @matcher = matcher
    @timeout = timeout
  end

  def matches?(block)
    @result = :block_never_yielded
    raise 'Actual should be wrapped in a block' unless block.respond_to? :call

    begin
      Timeout.timeout(@timeout) do
        loop do
          @result = block.call
          return true if @matcher.matches? @result
        rescue StandardError => e
          @last_error = e
          next
        end
      end
    rescue Timeout::Error
      return false
    end
  end

  def supports_block_expectations?
    true
  end

  def failure_message
    if @result == :block_never_yielded && @last_error
      "expected to eventually #{@matcher.description}, but last result threw #{@last_error.inspect}"
    else
      "expected to eventually #{@matcher.description}, but last result was #{@result.inspect}"
    end
  end
end
