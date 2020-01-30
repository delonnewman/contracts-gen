C = Contracts

RSpec.describe Contracts::Builtin do
  include Gen::Test
  
  Sum = lambda { |xs| xs.reduce(:+) }

  it 'should sum an array of integers' do
    for_all C::ArrayOf[Integer] do |xs|
      y = Sum[xs]
      expect(y).to be(xs.reduce(:+))
    end
  end

  it 'should generate valid values' do
    for_all C::Bool, C::Num, C::Int, C::BigInt, C::SmallInt, C::TinyInt, C::Neg, C::Pos, C::Nat do |a, b, c, d, e, f, g, h, i|
      expect(C::Bool.valid?(a)).to be(true)
      expect(C::Num.valid?(b)).to be(true)
      expect(C::Int.valid?(c)).to be(true)
      expect(C::BigInt.valid?(d)).to be(true)
      expect(C::SmallInt.valid?(e)).to be(true)
      expect(C::TinyInt.valid?(f)).to be(true)
      expect(C::Neg.valid?(g)).to be(true)
      expect(C::Pos.valid?(h)).to be(true)
      expect(C::Nat.valid?(i)).to be(true)
    end
  end

  context 'Maybe' do
    it 'should a value or nil' do
      for_all C::Maybe[C::Int] do |x|
        expect(x.nil? ? true : C::Int.valid?(x)).to be(true)
      end
    end
  end

  context 'HashOf' do
    it 'should generate a hash with keys and value of the specified type' do
      for_all C::HashOf[C::TinyInt, C::Bool] do |hash|
        expect(hash.keys.all? { |k| C::TinyInt.valid?(k) }).to be(true)
        expect(hash.values.all? { |k| C::Bool.valid?(k) }).to be(true)
      end
    end
  end

  context 'Or' do
    it 'should generate one of the types given' do
      for_all C::Or[C::TinyInt, C::Bool, C::ArrayOf[C::Int]] do |x|
        expect(C::TinyInt.valid?(x) || C::Bool.valid?(x) || C::ArrayOf[C::Int].valid?(x)).to be(true)
      end
    end
  end
end
