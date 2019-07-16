require 'contracts'

module Contracts::Builtin
  class Bool
    def self.generate(true_ratio = 0.5)
      Random.rand < true_ratio
    end
  end

  class Int
    def self.generate(*_args)
      i = Random.rand(10e10).to_i

      if Bool.generate
        i
      else
        i * -1
      end
    end
  end

  class Pos
    def self.generate(*_args)
      pos = Random.rand(10e10).to_i
      pos = Random.rand(10e10).to_i while pos.zero?
      pos
    end
  end

  class Nat
    def self.generate(*_args)
      Random.rand(10e10).to_i
    end
  end

  class Maybe
    def generate(*args)
      if Bool.generate
        @vals.reject(&:nil?).first.generate(*args)
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
    def generate(*_args)
      @vals.sample.generate
    end
  end
end
