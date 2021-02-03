def get_field_error(cmd)
  R_.get(cmd.errors, 'errors[0].field_errors.char')
end

def get_max_length_error_message(min_length: 0, max_length: 255)
  "This string field's length must be in range from #{min_length} to #{max_length}."
end