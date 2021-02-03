# required: true
# default: nil
# min: -2_000_000_000
# max: 2_000_000_000
# allow_nil: false

module BigintField
  class DefaultValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        age: bigint_field
      }
    end
  end

  class ValidMinValueValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        age: bigint_field(min: -2_000_000_001)
      }
    end
  end

  class ValidMaxValueValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        age: bigint_field(max: 2_000_000_001)
      }
    end
  end

  class InvalidMinValueValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        age: bigint_field(min: -2_000_000_000_001)
      }
    end
  end

  class InvalidMaxValueValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        age: bigint_field(max: 2_000_000_000_001)
      }
    end
  end
end