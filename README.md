Contracts::Gen
==============

An extension for [Gen::Test][1], defining generators for [Contracts][2].

Synopsis
========

```ruby
require 'gen/test'
require 'contracts'
require 'contracts/gen'

Sum = lambda { |xs| xs.reduce(:+) }

C = Contracts

class SumTest < Minitest::Test
  include Gen::Test

  def test_incremented_for_all_integers
    for_all C::ArrayOf[Integer] do |xs|
      y = Sum[xs]
      assert_equal(y, xs.reduce(:+))
    end
  end
end
```

Install
=======

    > gem install contracts-gen

or, add:

```ruby
gem 'contracts-gen'
```

to your Gemfile, and then execute:

    > bundle


See Also
========

- [Gen::Test][1]
- [Contracts][2]

[1]: https://github.com/delonnewman/gen-test
[2]: https://github.com/egonSchiele/contracts.ruby
