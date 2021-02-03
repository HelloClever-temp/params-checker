# required: true
# default: nil
# min: -2_000_000_000
# max: 2_000_000_000
# allow_nil: false

module BignumField
  class DefaultValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        age: bignum_field
      }
    end
  end

  class ValidMinValueValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        age: bignum_field(min: -2_000_000_001.5)
      }
    end
  end

  class ValidMaxValueValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        age: bignum_field(max: 2_000_000_001.5)
      }
    end
  end

  class InvalidMinValueValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        age: bignum_field(min: -2_000_000_000_001.5)
      }
    end
  end

  class InvalidMaxValueValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        age: bignum_field(max: 2_000_000_000_001.5)
      }
    end
  end
end