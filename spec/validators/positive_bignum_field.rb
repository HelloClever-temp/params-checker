# required: true
# default: nil
# min: -2_000_000_000
# max: 2_000_000_000
# allow_nil: false

module PositiveBignumField
  class DefaultValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        age: positive_bignum_field
      }
    end
  end

  class InvalidMinValueValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        age: positive_bignum_field(min: -1.5)
      }
    end
  end
end