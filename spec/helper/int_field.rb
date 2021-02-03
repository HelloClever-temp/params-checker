def get_field_error(cmd)
  R_.get(cmd.errors, 'errors[0].field_errors.age')
end

def get_max_value_error_message(min: -2_000_000_000, max: 2_000_000_000)
  "This integer field's value must be in range from #{min} to #{max}."
end