

module ParamsChecker
  module Fields
    def text_field(required: true, default: nil, allow_blank: false, min_length: 0, max_length: 10_000)
      raise "This field's type must be numeric." if [min_length, max_length].any? { |value| !value.is_a?(Numeric) }
      raise "This field's type must be boolean." if [required, allow_blank].any? { |value| !value.in? [true, false] }
      raise 'Invalid text length.' unless (min_length >= 0) && (max_length <= 10_000)
    
      {
          type: 'char',
          default: default,
          allow_blank: allow_blank,
          required: required,
          min_length: min_length,
          max_length: max_length
      }
    end
    
    def char_field(required: true, default: nil, allow_blank: false, min_length: 0, max_length: 255)
      raise "This field's type must be numeric." if [min_length, max_length].any? { |value| !value.is_a?(Numeric) }
      raise "This field's type must be boolean." if [required, allow_blank].any? { |value| !value.in? [true, false] }
      raise 'Invalid char length.' unless (min_length >= 0) && (max_length <= 255)
    
      {
          type: 'char',
          default: default,
          allow_blank: allow_blank,
          required: required,
          min_length: min_length,
          max_length: max_length
      }
    end
    
    def bignum_field(required: true, default: nil, min: -2_000_000_000_000, max: 2_000_000_000_000)
      raise "This field's type must be numeric." if [min, max].any? { |value| !value.is_a?(Numeric) }
      raise "This field's type must be boolean." if [required].any? { |value| !value.in? [true, false] }
      raise 'Invalid numeric value.' unless (min >= -2_000_000_000_000) && (max <= 2_000_000_000_000)
    
      {
          type: 'num',
          default: default,
          required: required,
          min: min,
          max: max
      }
    end
    
    def num_field(required: true, default: nil, min: -2_000_000_000, max: 2_000_000_000)
      raise "This field's type must be numeric." if [min, max].any? { |value| !value.is_a?(Numeric) }
      raise "This field's type must be boolean." if [required].any? { |value| !value.in? [true, false] }
      raise 'Invalid numeric value.' unless (min >= -2_000_000_000) && (max <= 2_000_000_000)
    
      {
          type: 'num',
          default: default,
          required: required,
          min: min,
          max: max
      }
    end
    
    def arr_field(required: true, default: nil, allow_empty: false)
      raise "This field's type must be boolean." if [required, allow_empty].any? { |value| !value.in? [true, false] }
    
      {
          type: 'arr',
          default: default,
          required: required,
          allow_empty: allow_empty
      }
    end
    
    def date_field(required: true, default: nil)
      raise "This field's type must be boolean." if [required].any? { |value| !value.in? [true, false] }
    
      {
          type: 'date',
          default: default,
          required: required
      }
    end
    
    def time_field(required: true, default: nil)
      raise "This field's type must be boolean." if [required].any? { |value| !value.in? [true, false] }
    
      {
          type: 'time',
          default: default,
          required: required
      }
    end
    
    def datetime_field(required: true, default: nil)
      raise "This field's type must be boolean." if [required].any? { |value| !value.in? [true, false] }
    
      {
          type: 'datetime',
          default: default,
          required: required
      }
    end

    def email_field(required: true, default: nil)
      raise "This field's type must be boolean." if [required].any? { |value| !value.in? [true, false] }
    
      {
          type: 'email',
          default: default,
          required: required
      }
    end

    def boolean_field(required: true, default: nil)
      raise "This field's type must be boolean." if [required].any? { |value| !value.in? [true, false] }
    
      {
          type: 'boolean',
          default: default,
          required: required
      }
    end

  end
  
end
