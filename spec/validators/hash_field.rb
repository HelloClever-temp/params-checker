# required: true
# default: nil
# allow_nil: false

module HashField
  class DefaultValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        person: hash_field
      }
    end
  end

  class DefaultValueIsPresentValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        person: hash_field(default: { name: 'Vu' })
      }
    end
  end

  class DefaultValueIsAbsentValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        person: hash_field
      }
    end
  end

  class NotRequiredValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        person: hash_field(required: false)
      }
    end
  end

  class RequiredValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        person: hash_field(required: true)
      }
    end
  end

  class MinValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        person: hash_field(min: 10)
      }
    end
  end

  class MaxValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        person: hash_field(max: 9)
      }
    end
  end

  class NotAllowNilValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        person: hash_field(allow_nil: false)
      }
    end
  end

  class AllowNilValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        person: hash_field(allow_nil: true)
      }
    end
  end

  class InvalidMinTypeValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        person: hash_field(min: 'invalid_min')
      }
    end
  end

  class InvalidMaxTypeValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        person: hash_field(max: 'invalid_max')
      }
    end
  end

  class InvalidRequiredTypeValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        person: hash_field(required: 'invalid_required')
      }
    end
  end

  class InvalidAllowNilTypeValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        person: hash_field(allow_nil: 'invalid_allow_nil')
      }
    end
  end

  class InvalidMinValueValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        person: hash_field(min: -2_000_000_001)
      }
    end
  end

  class InvalidMaxValueValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        person: hash_field(max: 2_000_000_001)
      }
    end
  end
end