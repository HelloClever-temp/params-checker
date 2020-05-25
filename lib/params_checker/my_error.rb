# frozen_string_literal: true

module ParamsChecker
  class MyError < StandardError
    def initialize(message)
        super(message)
    end
  end
end
