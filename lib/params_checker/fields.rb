# frozen_string_literal: true

module ParamsChecker
  module Fields
    def text_field(
      required: true,
      default: nil,
      allow_blank: false,
      min_length: 0,
      max_length: 30_000,
      allow_nil: false
    )
      Helper.check_type(type: 'integer', values: [min_length, max_length])
      Helper.check_type(type: 'boolean', values: [required, allow_blank, allow_nil])
      raise 'Invalid text length.' unless (min_length >= 0) && (max_length <= 30_000)

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

    def char_field(
      required: true,
      default: nil,
      allow_blank: false,
      min_length: 0,
      max_length: 255,
      allow_nil: false
    )
      Helper.check_type(type: 'integer', values: [min_length, max_length])
      Helper.check_type(type: 'boolean', values: [required, allow_blank, allow_nil])
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

    def bignum_field(
      required: true,
      default: nil,
      min: -2_000_000_000_000,
      max: 2_000_000_000_000,
      allow_nil: false
    )
      Helper.check_type(type: 'numeric', values: [min, max])
      Helper.check_type(type: 'boolean', values: [required, allow_nil])
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

    def num_field(
      required: true,
      default: nil,
      min: -2_000_000_000,
      max: 2_000_000_000,
      allow_nil: false
    )
      Helper.check_type(type: 'numeric', values: [min, max])
      Helper.check_type(type: 'boolean', values: [required, allow_nil])
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

    def bigint_field(
      required: true,
      default: nil,
      min: -2_000_000_000_000,
      max: 2_000_000_000_000,
      allow_nil: false
    )
      Helper.check_type(type: 'integer', values: [min, max])
      Helper.check_type(type: 'boolean', values: [required, allow_nil])
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

    def int_field(
      required: true,
      default: nil,
      min: -2_000_000_000,
      max: 2_000_000_000,
      allow_nil: false
    )
      Helper.check_type(type: 'integer', values: [min, max])
      Helper.check_type(type: 'boolean', values: [required, allow_nil])
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

    def positive_bignum_field(
      required: true,
      default: nil,
      min: 0, max: 2_000_000_000_000,
      allow_nil: false
    )
      Helper.check_type(type: 'numeric', values: [min, max])
      Helper.check_type(type: 'boolean', values: [required, allow_nil])
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

    def positive_num_field(
      required: true,
      default: nil,
      min: 0,
      max: 2_000_000_000, 
      allow_nil: false
    )
      Helper.check_type(type: 'numeric', values: [min, max])
      Helper.check_type(type: 'boolean', values: [required, allow_nil])
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

    def positive_bigint_field(
      required: true,
      default: nil,
      min: 0,
      max: 2_000_000_000_000,
      allow_nil: false
    )
      Helper.check_type(type: 'integer', values: [min, max])
      Helper.check_type(type: 'boolean', values: [required, allow_nil])
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

    def positive_int_field(
      required: true,
      default: nil,
      min: 0,
      max: 2_000_000_000,
      allow_nil: false
    )
      Helper.check_type(type: 'integer', values: [min, max])
      Helper.check_type(type: 'boolean', values: [required, allow_nil])
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

    def arr_field(
      required: true,
      default: nil,
      allow_empty: false,
      allow_nil: false
    )
      Helper.check_type(type: 'boolean', values: [required, allow_empty, allow_nil])

      {
        type: 'arr',
        default: default,
        required: required,
        allow_empty: allow_empty,
        allow_nil: allow_nil
      }
    end

    def hash_field(
      required: true,
      default: nil,
      allow_nil: false
    )
      Helper.check_type(type: 'boolean', values: [required, allow_nil])

      {
        type: 'hash',
        default: default,
        required: required,
        allow_nil: allow_nil
      }
    end

    def date_field(
      required: true,
      default: nil,
      allow_nil: false
    )
      Helper.check_type(type: 'boolean', values: [required, allow_nil])

      {
        type: 'date',
        default: default,
        required: required,
        allow_nil: allow_nil
      }
    end

    def time_field(
      required: true,
      default: nil,
      allow_nil: false
    )
      Helper.check_type(type: 'boolean', values: [required, allow_nil])

      {
        type: 'time',
        default: default,
        required: required,
        allow_nil: allow_nil
      }
    end

    def datetime_field(
      required: true,
      default: nil,
      allow_nil: false
    )
      Helper.check_type(type: 'boolean', values: [required, allow_nil])

      {
        type: 'datetime',
        default: default,
        required: required,
        allow_nil: allow_nil
      }
    end

    def email_field(
      required: true,
      default: nil,
      allow_nil: false
    )
      Helper.check_type(type: 'boolean', values: [required, allow_nil])

      {
        type: 'email',
        default: default,
        required: required,
        allow_nil: allow_nil
      }
    end

    def boolean_field(
      required: true,
      default: nil,
      allow_nil: false
    )
      Helper.check_type(type: 'boolean', values: [required, allow_nil])

      {
        type: 'boolean',
        default: default,
        required: required,
        allow_nil: allow_nil
      }
    end
  end
end
