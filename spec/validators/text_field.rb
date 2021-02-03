# required: true
# allow_blank: false
# default: nil
# min_length: 0
# max_length: 255
# allow_nil: false

module TextField
  class InvalidMaxLengthValueValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        name: text_field(max_length: 30_001)
      }
    end
  end

  class ValidMaxLengthValueValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        name: text_field(max_length: 256)
      }
    end
  end

  class DefaultValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        name: text_field
      }
    end
  end
end