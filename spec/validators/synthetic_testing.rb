# type: type
# required: required
# default: default
# many: many
# class: self

module Synthetic
  class DefaultPersonValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        example_boolean_field: boolean_field,
        example_date_field: date_field,
        example_text_field: text_field,
        example_char_field: char_field,
        example_num_field: num_field,
        example_bignum_field: bignum_field,
        example_bigint_field: bigint_field,
        example_int_field: int_field,
        example_positive_bignum_field: positive_bignum_field,
        example_positive_num_field: positive_num_field,
        example_positive_bigint_field: positive_bigint_field,
        example_positive_int_field: positive_int_field,
        example_arr_field: arr_field,
        example_hash_field: DefaultExampleHashFieldValidator.init,
        example_time_field: time_field,
        example_datetime_field: datetime_field
      }
    end
  end

  class DefaultExampleHashFieldValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        money: bigint_field,
        birth_time: time_field
      }
    end
  end

  class DefaultValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        person: DefaultPersonValidator.init
      }
    end
  end
end