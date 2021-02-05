# frozen_string_literal: true

module ParamsChecker
  class FieldError < StandardError
    attr_accessor :data

    def initialize(data)
      @data = data
    end
  end
end
