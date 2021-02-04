# required: true
# default: nil
# allow_nil: false

module TimeField
  class DefaultValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        created_at: time_field
      }
    end
  end

  class DefaultValueIsPresentValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        created_at: time_field(default: '12:00')
      }
    end
  end

  class DefaultValueIsAbsentValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        created_at: time_field
      }
    end
  end

  class NotRequiredValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        created_at: time_field(required: false)
      }
    end
  end

  class RequiredValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        created_at: time_field(required: true)
      }
    end
  end

  class NotAllowNilValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        created_at: time_field(allow_nil: false)
      }
    end
  end

  class AllowNilValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        created_at: time_field(allow_nil: true)
      }
    end
  end

  class InvalidRequiredTypeValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        created_at: time_field(required: 'invalid_required')
      }
    end
  end

  class InvalidAllowNilTypeValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        created_at: time_field(allow_nil: 'invalid_allow_nil')
      }
    end
  end
end