require "contracts/gen/version"
require "contracts/builtin_ext"
require 'gen/test'
require 'faker'

module Contracts
  class Keys
    def self.[](spec)
      if spec[:required] and spec[:optional]
        new(spec[:required], spec[:optional])
      elsif spec[:required]
        new(spec[:required], nil)
      elsif spec[:optional]
        new(nil, spec[:optional])
      else
        raise "Invalid hash spec: #{spec.inspect}"
      end
    end

    def initialize(required, optional)
      @required = required
      @optional = optional
    end

    def valid?(value)
      if not value.respond_to?(:[])
        false
      else
        @required.all? { |(k, v)| Contract.valid?(value[k], v) }
      end
    end

    def generate
      h = {}
      unless @required.nil? or @required.empty?
        @required.each do |(k, contract)|
          h[k] = ::Gen.generate(contract)
        end
      end
      unless @optional.nil? or @optional.empty?
        n = Faker::Number.between(0, @optional.keys.length)
        keys = @optional.keys.sample(n)
        keys.each do |k|
          contract = @optional[k]
          h[k] = ::Gen.generate(contract)
        end
      end
      h
    end
  end
end
