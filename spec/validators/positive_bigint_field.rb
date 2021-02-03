# required: true
# default: nil
# min: -2_000_000_000
# max: 2_000_000_000
# allow_nil: false

module PositiveBigintField
  class DefaultValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        age: positive_bigint_field
      }
    end
  end

  class InvalidMinValueValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        age: positive_bigint_field(min: -1)
      }
    end
  end
end