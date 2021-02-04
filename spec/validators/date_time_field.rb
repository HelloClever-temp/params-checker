# required: true
# default: nil
# allow_nil: false

module DateTimeField
  class DefaultValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        created_at: datetime_field
      }
    end
  end

  class DefaultValueIsPresentValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        created_at: datetime_field(default: '2020-01-01 04:05:06')
      }
    end
  end

  class DefaultValueIsAbsentValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        created_at: datetime_field
      }
    end
  end

  class NotRequiredValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        created_at: datetime_field(required: false)
      }
    end
  end

  class RequiredValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        created_at: datetime_field(required: true)
      }
    end
  end

  class NotAllowNilValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        created_at: datetime_field(allow_nil: false)
      }
    end
  end

  class AllowNilValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        created_at: datetime_field(allow_nil: true)
      }
    end
  end

  class InvalidRequiredTypeValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        created_at: datetime_field(required: 'invalid_required')
      }
    end
  end

  class InvalidAllowNilTypeValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        created_at: datetime_field(allow_nil: 'invalid_allow_nil')
      }
    end
  end
end