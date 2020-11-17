# frozen_string_literal: true

module ParamsChecker
  class GeneralError < StandardError
    def initialize(message)
      super(message)
    end
  end
end
