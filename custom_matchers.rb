require 'rspec'
require 'timeout'

class Eventually
  def initialize(matcher, timeout: 10) # change to read config?
    @matcher = matcher
    @timeout = timeout
  end

  def matches?(block)
    raise 'Actual should be wrapped in a block' unless block.respond_to? :call
    begin
      Timeout.timeout(@timeout) do
        loop do
          begin
            @result = block.call
            return true if @matcher.matches? @result
          rescue
            next
          end
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
    "expected to eventually #{@matcher.description}, but last result was #{@result.inspect}"
  end
end
