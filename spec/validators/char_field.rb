# required: true
# allow_blank: false
# default: nil
# min_length: 0
# max_length: 255
# allow_nil: false

module CharField
  class DefaultValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        name: char_field
      }
    end
  end

  class DefaultValueIsPresentValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        name: char_field(default: 'default_char')
      }
    end
  end

  class DefaultValueIsAbsentValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        name: char_field
      }
    end
  end

  class NotRequiredValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        name: char_field(required: false)
      }
    end
  end

  class RequiredValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        name: char_field(required: true)
      }
    end
  end

  class NotAllowBlankValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        name: char_field(allow_blank: false)
      }
    end
  end

  class AllowBlankValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        name: char_field(allow_blank: true)
      }
    end
  end

  class MinLengthValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        name: char_field(min_length: 10)
      }
    end
  end

  class MaxLengthValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        name: char_field(max_length: 9)
      }
    end
  end

  class NotAllowNilValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        name: char_field(allow_nil: false)
      }
    end
  end

  class AllowNilValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        name: char_field(allow_nil: true)
      }
    end
  end

  class InvalidMinLengthTypeValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        name: char_field(min_length: 'invalid_min_length')
      }
    end
  end

  class InvalidMaxLengthTypeValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        name: char_field(max_length: 'invalid_max_length')
      }
    end
  end

  class InvalidRequiredTypeValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        name: char_field(required: 'invalid_required')
      }
    end
  end

  class InvalidAllowBlankTypeValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        name: char_field(allow_blank: 'invalid_allow_blank')
      }
    end
  end

  class InvalidAllowNilTypeValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        name: char_field(allow_nil: 'invalid_allow_nil')
      }
    end
  end

  class InvalidMinLengthValueValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        name: char_field(min_length: -1)
      }
    end
  end

  class InvalidMaxLengthValueValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        name: char_field(max_length: 256)
      }
    end
  end
end