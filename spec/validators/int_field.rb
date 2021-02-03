# required: true
# default: nil
# min: -2_000_000_000
# max: 2_000_000_000
# allow_nil: false

module IntField
  class DefaultValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        age: int_field
      }
    end
  end

  class DefaultValueIsPresentValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        age: int_field(default: 3)
      }
    end
  end

  class DefaultValueIsAbsentValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        age: int_field
      }
    end
  end

  class NotRequiredValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        age: int_field(required: false)
      }
    end
  end

  class RequiredValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        age: int_field(required: true)
      }
    end
  end

  class MinValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        age: int_field(min: 10)
      }
    end
  end

  class MaxValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        age: int_field(max: 9)
      }
    end
  end

  class NotAllowNilValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        age: int_field(allow_nil: false)
      }
    end
  end

  class AllowNilValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        age: int_field(allow_nil: true)
      }
    end
  end

  class InvalidMinTypeValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        age: int_field(min: 'invalid_min')
      }
    end
  end

  class InvalidMaxTypeValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        age: int_field(max: 'invalid_max')
      }
    end
  end

  class InvalidRequiredTypeValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        age: int_field(required: 'invalid_required')
      }
    end
  end

  class InvalidAllowNilTypeValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        age: int_field(allow_nil: 'invalid_allow_nil')
      }
    end
  end

  class InvalidMinValueValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        age: int_field(min: -2_000_000_001)
      }
    end
  end

  class InvalidMaxValueValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        age: int_field(max: 2_000_000_001)
      }
    end
  end
end