module CharacterFieldValidators
  class DefaultValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        char: char_field
      }
    end
  end

  # required: true,
  # default: nil,
  # allow_blank: false,

  # min_length: 0,
  # max_length: 255,
  # allow_nil: false

  class DefaultValueValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        char: char_field(default: 'default_char')
      }
    end
  end

  class NotRequiredValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        char: char_field(required: false)
      }
    end
  end

  class RequiredValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        char: char_field(required: true)
      }
    end
  end

  class NotAllowBlankValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        char: char_field(allow_blank: false)
      }
    end
  end

  class AllowBlankValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        char: char_field(allow_blank: true)
      }
    end
  end

  class NotSetMinLengthValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        char: char_field
      }
    end
  end

  class SetMinLengthValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        char: char_field(min_length: 10)
      }
    end
  end
end