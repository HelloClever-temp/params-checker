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
        name: text_field(max_length: 300001)
      }
    end
  end

  class ValidMaxLengthValueValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        name: text_field(max_length: 3000)
      }
    end
  end
end