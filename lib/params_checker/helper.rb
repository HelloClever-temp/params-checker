# frozen_string_literal: true

module ParamsChecker
  module Helper
    extend self

    def check_type(
      type: '',
      values: []
    )
      case type
      when 'integer'
        raise "This field's type must be integer." if values.any? { |value| !value.is_a?(Integer) }
      when 'numberic'
        raise "This field's type must be numberic." if values.any? { |value| !value.is_a?(Numeric) }
      when 'boolean'
        raise "This field's type must be boolean." if values.any? { |value| !value.in? [true, false] }
      end
    end
  end
end
