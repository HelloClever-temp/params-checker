# required: true
# default: nil
# min: -2_000_000_000
# max: 2_000_000_000
# allow_nil: false

module PositiveIntField
  class DefaultValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        age: positive_int_field
      }
    end
  end

  class InvalidMinValueValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        age: positive_int_field(min: -1)
      }
    end
  end
end