require 'rspec'
require_relative '../custom_matchers'

include RSpec

describe :eventually do
  it 'Evaluates the block and passes the return value to a matcher' do
    expect {4}.to eventually be 4
    expect {5}.not_to eventually eq 4
  end

  it 'Evaluates the block multiple times until a match is produced' do
    v = 0
    expect {v += 1}.to eventually be 3
  end

  it 'Raises a custom error message when failing' do
    example = -> { expect{5}.to eventually be 3 }

    expect(example).to raise_error('expected to eventually equal 3, but last result was 5')
  end
end

