# required: true
# default: nil
# allow_empty: false
# allow_nil: false

module ArrField
  class DefaultValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        books: arr_field
      }
    end
  end

  class DefaultValueIsPresentValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        books: arr_field(default: ['Harry Potter'])
      }
    end
  end

  class DefaultValueIsAbsentValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        books: arr_field
      }
    end
  end

  class NotRequiredValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        books: arr_field(required: false)
      }
    end
  end

  class RequiredValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        books: arr_field(required: true)
      }
    end
  end

  class NotAllowEmptyValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        books: arr_field(allow_empty: false)
      }
    end
  end

  class AllowEmptyValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        books: arr_field(allow_empty: true)
      }
    end
  end

  class NotAllowNilValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        books: arr_field(allow_nil: false)
      }
    end
  end

  class AllowNilValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        books: arr_field(allow_nil: true)
      }
    end
  end

  class InvalidRequiredTypeValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        books: arr_field(required: 'invalid_required')
      }
    end
  end

  class InvalidAllowEmptyTypeValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        books: arr_field(allow_empty: 'invalid_allow_empty')
      }
    end
  end

  class InvalidAllowNilTypeValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        books: arr_field(allow_nil: 'invalid_allow_nil')
      }
    end
  end
end