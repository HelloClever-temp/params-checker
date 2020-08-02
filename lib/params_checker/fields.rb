

module ParamsChecker
  module Fields
    def text_field(required: true, default: nil, allow_blank: false, min_length: 0, max_length: 10_000, allow_nil: false)
      raise "This field's type must be integer." if [min_length, max_length].any? { |value| !value.is_a?(Integer) }
      raise "This field's type must be boolean." if [required, allow_blank, allow_nil].any? { |value| !value.in? [true, false] }
      raise 'Invalid text length.' unless (min_length >= 0) && (max_length <= 10_000)
    
      {
          type: 'char',
          default: default,
          allow_blank: allow_blank,
          required: required,
          min_length: min_length,
          max_length: max_length,
          allow_nil: allow_nil
      }
    end
    
    def char_field(required: true, default: nil, allow_blank: false, min_length: 0, max_length: 255, allow_nil: false)
      raise "This field's type must be integer." if [min_length, max_length].any? { |value| !value.is_a?(Integer) }
      raise "This field's type must be boolean." if [required, allow_blank, allow_nil].any? { |value| !value.in? [true, false] }
      raise 'Invalid char length.' unless (min_length >= 0) && (max_length <= 255)
    
      {
          type: 'char',
          default: default,
          allow_blank: allow_blank,
          required: required,
          min_length: min_length,
          max_length: max_length,
          allow_nil: allow_nil
      }
    end
    
    def bignum_field(required: true, default: nil, min: -2_000_000_000_000, max: 2_000_000_000_000, allow_nil: false)
      raise "This field's type must be numeric." if [min, max].any? { |value| !value.is_a?(Numeric) }
      raise "This field's type must be boolean." if [required, allow_nil].any? { |value| !value.in? [true, false] }
      raise 'Invalid numeric value.' unless (min >= -2_000_000_000_000) && (max <= 2_000_000_000_000)
    
      {
          type: 'num',
          default: default,
          required: required,
          min: min,
          max: max,
          allow_nil: allow_nil
      }
    end
    
    def num_field(required: true, default: nil, min: -2_000_000_000, max: 2_000_000_000, allow_nil: false)
      raise "This field's type must be numeric." if [min, max].any? { |value| !value.is_a?(Numeric) }
      raise "This field's type must be boolean." if [required, allow_nil].any? { |value| !value.in? [true, false] }
      raise 'Invalid numeric value.' unless (min >= -2_000_000_000) && (max <= 2_000_000_000)
    
      {
          type: 'num',
          default: default,
          required: required,
          min: min,
          max: max,
          allow_nil: allow_nil
      }
    end

    def bigint_field(required: true, default: nil, min: -2_000_000_000_000, max: 2_000_000_000_000, allow_nil: false)
      raise "This field's type must be integer." if [min, max].any? { |value| !value.is_a?(Integer) }
      raise "This field's type must be boolean." if [required, allow_nil].any? { |value| !value.in? [true, false] }
      raise 'Invalid integer value.' unless (min >= -2_000_000_000_000) && (max <= 2_000_000_000_000)
    
      {
          type: 'int',
          default: default,
          required: required,
          min: min,
          max: max,
          allow_nil: allow_nil
      }
    end
    
    def int_field(required: true, default: nil, min: -2_000_000_000, max: 2_000_000_000, allow_nil: false)
      raise "This field's type must be integer." if [min, max].any? { |value| !value.is_a?(Integer) }
      raise "This field's type must be boolean." if [required, allow_nil].any? { |value| !value.in? [true, false] }
      raise 'Invalid integer value.' unless (min >= -2_000_000_000) && (max <= 2_000_000_000)
    
      {
          type: 'int',
          default: default,
          required: required,
          min: min,
          max: max,
          allow_nil: allow_nil
      }
    end

    # asdasda

    def positive_bignum_field(required: true, default: nil, min: 0, max: 2_000_000_000_000, allow_nil: false)
      raise "This field's type must be numeric." if [min, max].any? { |value| !value.is_a?(Numeric) }
      raise "This field's type must be boolean." if [required, allow_nil].any? { |value| !value.in? [true, false] }
      raise 'Invalid numeric value.' unless (min >= 0) && (max <= 2_000_000_000_000)
    
      {
          type: 'num',
          default: default,
          required: required,
          min: min,
          max: max,
          allow_nil: allow_nil
      }
    end
    
    def positive_num_field(required: true, default: nil, min: 0, max: 2_000_000_000, allow_nil: false)
      raise "This field's type must be numeric." if [min, max].any? { |value| !value.is_a?(Numeric) }
      raise "This field's type must be boolean." if [required, allow_nil].any? { |value| !value.in? [true, false] }
      raise 'Invalid numeric value.' unless (min >= 0) && (max <= 2_000_000_000)
    
      {
          type: 'num',
          default: default,
          required: required,
          min: min,
          max: max,
          allow_nil: allow_nil
      }
    end

    def positive_bigint_field(required: true, default: nil, min: 0, max: 2_000_000_000_000, allow_nil: false)
      raise "This field's type must be integer." if [min, max].any? { |value| !value.is_a?(Integer) }
      raise "This field's type must be boolean." if [required, allow_nil].any? { |value| !value.in? [true, false] }
      raise 'Invalid integer value.' unless (min >= 0) && (max <= 2_000_000_000_000)
    
      {
          type: 'int',
          default: default,
          required: required,
          min: min,
          max: max,
          allow_nil: allow_nil
      }
    end
    
    def positive_int_field(required: true, default: nil, min: 0, max: 2_000_000_000, allow_nil: false)
      raise "This field's type must be integer." if [min, max].any? { |value| !value.is_a?(Integer) }
      raise "This field's type must be boolean." if [required, allow_nil].any? { |value| !value.in? [true, false] }
      raise 'Invalid integer value.' unless (min >= 0) && (max <= 2_000_000_000)
    
      {
          type: 'int',
          default: default,
          required: required,
          min: min,
          max: max,
          allow_nil: allow_nil
      }
    end
    
    def arr_field(required: true, default: nil, allow_empty: false, allow_nil: false)
      raise "This field's type must be boolean." if [required, allow_empty, allow_nil].any? { |value| !value.in? [true, false] }
    
      {
          type: 'arr',
          default: default,
          required: required,
          allow_empty: allow_empty,
          allow_nil: allow_nil
      }
    end
    
    def date_field(required: true, default: nil, allow_nil: false)
      raise "This field's type must be boolean." if [required, allow_nil].any? { |value| !value.in? [true, false] }
    
      {
          type: 'date',
          default: default,
          required: required,
          allow_nil: allow_nil
      }
    end
    
    def time_field(required: true, default: nil, allow_nil: false)
      raise "This field's type must be boolean." if [required, allow_nil].any? { |value| !value.in? [true, false] }
    
      {
          type: 'time',
          default: default,
          required: required,
          allow_nil: allow_nil
      }
    end
    
    def datetime_field(required: true, default: nil, allow_nil: false)
      raise "This field's type must be boolean." if [required, allow_nil].any? { |value| !value.in? [true, false] }
    
      {
          type: 'datetime',
          default: default,
          required: required,
          allow_nil: allow_nil
      }
    end

    def email_field(required: true, default: nil, allow_nil: false)
      raise "This field's type must be boolean." if [required, allow_nil].any? { |value| !value.in? [true, false] }
    
      {
          type: 'email',
          default: default,
          required: required,
          allow_nil: allow_nil
      }
    end

    def boolean_field(required: true, default: nil, allow_nil: false)
      raise "This field's type must be boolean." if [required, allow_nil].any? { |value| !value.in? [true, false] }
    
      {
          type: 'boolean',
          default: default,
          required: required,
          allow_nil: allow_nil
      }
    end

  end
  
end
