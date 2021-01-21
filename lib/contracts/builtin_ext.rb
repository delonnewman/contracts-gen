require 'contracts'

module Contracts::Builtin
  class Bool
    def self.generate(true_ratio: 0.5)
      Random.rand < true_ratio
    end
  end

  class Num
    def self.generate(min: -2e31.to_f, max: (2e31 - 1).to_f)
      raise 'min should not be greater than max' if min > max
      Random.rand(min..max)
    end
  end

  class Int
    def self.generate(min: -2e31, max: 2e31 - 1, neg_ratio: 0.5)
      min_pos = min < 0 ? 0 : min
      max_neg = max > -1 ? -1 : max

      if Bool.generate(true_ratio: neg_ratio)
        Num.generate(min: min, max: max_neg).to_i
      else
        Num.generate(min: min_pos, max: max).to_i
      end
    end
  end

  class BigInt < Int
    def self.generate(min: -2e63, max: 2e63 - 1)
      super(min: min, max: max)
    end
  end

  class SmallInt < Int
    def self.generate(min: -2e15, max: 2e15 - 1)
      super(min: min, max: max)
    end
  end

  class TinyInt < Int
    def self.generate(min: -255, max: 255)
      super(min: min, max: max)
    end
  end

  class Neg
    def self.generate(min: -1_000, max: -1)
      raise 'max should not be greater than -1' if max > -1
      Num.generate(min: min, max: max).to_i
    end
  end

  class Pos
    def self.generate(min: 1, max: 1_000)
      raise 'min should not be less than 1' if min < 1
      Num.generate(min: min, max: max).to_i
    end
  end

  class Nat
    def self.generate(min: 0, max: 1_000)
      raise 'min should not be less than 0' if min < 0
      Num.generate(min: min, max: max).to_i
    end
  end

  class Maybe
    def generate(nil_ratio: 0.5)
      if Bool.generate(true_ratio: nil_ratio)
        @vals.reject(&:nil?).first.generate
      else
        nil
      end
    end
  end

  class CollectionOf
    def generate(min: 0, max: 30)
      @collection_class.generate(min: min, max: max, type: @contract)
    end
  end

  class HashOf
    def generate(min: 0, max: 30)
      Hash.generate(min: min, max: max, value_type: @value, key_type: @key)
    end
  end

  class Or
    def generate
      @vals.sample.generate
    end
  end
end
