# frozen_string_literal: true

module ParamsChecker
  class FieldError < StandardError
    def initialize(message)
      super(message)
    end
  end
end
