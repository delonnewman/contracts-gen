C = Contracts

RSpec.describe Contracts::Gen do
  include Gen::Test
  
  Sum = lambda { |xs| xs.reduce(:+) }

  it 'should sum an array of integers' do
    for_all C::ArrayOf[Integer] do |xs|
      y = Sum[xs]
      expect(y).to be(xs.reduce(:+))
    end
  end
end
