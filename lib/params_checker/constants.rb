# frozen_string_literal: true

class Constants
  ERROR_MESSAGES = {
    required: 'This field is required.',
    blank: 'This field cannot be blank.',
    empty: 'This field cannot be empty.',

    type: {
      string: "This field's type must be string.",
      file: "This field's type must be file.",
      hash: "This field's type must be hash.",
      nested_hash: "This field's type must be object or ActionController::Parameters.",
      array: "This field's type must be array.",
      integer: "This field's type must be integer.",
      numeric: "This field's type must be numeric.",
      boolean: "This field's type must be boolean.",
      date: 'Invalid date.',
      time: 'Invalid time.',
      datetime: 'Invalid datetime.'
    },

    length: {
      text: 'Invalid text length.',
      char: 'Invalid char length.'
    },

    value: {
      numeric: 'Invalid numeric value.',
      integer: 'Invalid integer value.'
    }
  }.freeze

  def get_integer_value_error_message(min: -2_000_000_000_000, max: 2_000_000_000_000)
    "This integer field's value must be in range from #{min} to #{max}."
  end

  def get_numeric_value_error_message(min: -2_000_000_000_000, max: 2_000_000_000_000)
    "This numeric field's value must be in range from #{min} to #{max}."
  end

  def get_string_length_error_message(min_length: 0, max_length: 30_000)
    "This string field's length must be in range from #{min_length} to #{max_length}."
  end
end
