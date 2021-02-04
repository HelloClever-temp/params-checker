# frozen_string_literal: true

DEFAULT_MESSAGE_ERROR = 'Fields are not valid'
ERROR_TYPES = %w[general_error field_errors]
module ParamsChecker
  class BaseParamsChecker
    include Fields
    prepend SimpleCommand
    def initialize(params: {}, context: {}, is_outest_hash: true)
      @params = params
      @context = context
      @is_outest_hash = is_outest_hash
      @formatted_params_after_default_fields_check = {}
      @formatted_params_after_custom_fields_check = {}
      @formatted_params_after_custom_overall_check = {}
      @custom_check_errors = {}
    end

    def self.init(required: true, many: false)
      raise "This field's type must be boolean." if [required, many].any? { |value| !value.in? [true, false] }

      type = many ? 'nested_hashs' : 'nested_hash'

      {
        type: type,
        required: required,
        many: many,
        class: self
      }
    end

    def raise_error(message = DEFAULT_MESSAGE_ERROR)
      raise GeneralError.new(message)
    end

    def add_error(message)
      # TODO: add second parameter to add_error(:code, 'invalid code')
      raise FieldError.new(message)
    end

    def call
      default_fields_check && custom_check
      error_exist? && add_errors
      formatted_params
    rescue ParamsChecker::GeneralError => e
      p "========>GeneralError : ", e

      # if is the outest hash, add error
      # if is not, keep raising error, bubble up to the outest hash,
      # then the outest hash will add error
      unless is_outest_hash
        raise e
      end

      errors.add(
        :errors,
        {
          message: e,
          error_type: 'general_error'
        }
      )
    end

    def error_exist?
      errors.present? && errors.is_a?(Hash) || @custom_check_errors.present?
    end

    def default_fields_check
      params_is_not_a_hash = !params.is_a?(ActionController::Parameters) && !params.is_a?(Hash)

      if params_is_not_a_hash
        errors.add(:error, 'ParamsChecker only receive object or ActionController::Parameters as input.')
      end

      all_fields_of_params_are_valid?
    end

    def custom_check
      fields_check && overall_check
    end

    def all_fields_of_params_are_valid?
      @all_fields_of_params_are_valid ||=
        schema.all? do |key, _|
          set_default_value(key) if need_to_set_default_value?(key)

          field_is_valid?(key)
        end
    end

    def field_is_valid?(key)
      return value_valid?(key) if value_present?(key)

      return true unless value_need_to_be_present?(key)

      errors.add(key, 'This field is required.')
      false
    end

    def need_to_set_default_value?(key)
      value_is_nil = @params[key].nil?
      schema_field_has_default_value_key = schema[key].key?(:default)
      default_value_is_set = !schema[key][:default].nil?

      value_is_nil &&
        schema_field_has_default_value_key &&
        default_value_is_set
    end

    def set_default_value(key)
      @params[key] = schema[key][:default]
    end

    def value_need_to_be_present?(key)
      return true if schema[key].key?(:default) && !schema[key][:default].nil?

      schema[key][:required]
    end

    def value_present?(key)
      params.key?(key)
    end

    def value_valid?(key)
      cmd = check_base_on_field_type(key)
      if cmd.success?
        @formatted_params_after_default_fields_check[key] = cmd.result
      else
        errors.add(key, cmd.errors[key])
      end
      cmd.success?
    end

    def schema
      @schema ||= init.each_with_object({}) do |error, hash|
        key, value = error
        hash[key] = value
      end
    end

    def check_base_on_field_type(key)
      case schema[key][:type]
      when 'num'
        ParamChecker::NumParamChecker.call(key, schema, params)
      when 'int'
        ParamChecker::IntParamChecker.call(key, schema, params)
      when 'char'
        ParamChecker::CharParamChecker.call(key, schema, params)
      when 'text'
        ParamChecker::CharParamChecker.call(key, schema, params)
      when 'arr'
        ParamChecker::ArrParamChecker.call(key, schema, params)
      when 'hash'
        ParamChecker::HashParamChecker.call(key, schema, params)
      when 'nested_hash'
        ParamChecker::NestedHashChecker.call(key, schema, params, context)
      when 'nested_hashs'
        ParamChecker::NestedHashsChecker.call(key, schema, params, context)
      when 'date'
        ParamChecker::DateParamChecker.call(key, schema, params)
      when 'time'
        ParamChecker::TimeParamChecker.call(key, schema, params)
      when 'datetime'
        ParamChecker::DateTimeParamChecker.call(key, schema, params)
      when 'boolean'
        ParamChecker::BooleanChecker.call(key, schema, params)
      when 'file'
        ParamChecker::FileChecker.call(key, schema, params)
      end
    end

    def fields_check
      @formatted_params_after_custom_fields_check = formatted_params_after_default_fields_check
      schema.each do |key, value|
        # next unless self.methods.grep(/check_#{key}/).length > 0
        need_to_check = "check_#{key}".to_sym.in?(methods)
        passed_default_check = errors[key].nil?

        next unless need_to_check && passed_default_check

        field_check(key)
      end
    end

    def field_check(key)
      check_method = "check_#{key}"
      total_parameters = method(check_method).arity

      value = if total_parameters == 1
                # like check_name(name)
                send(check_method, @formatted_params_after_default_fields_check[key])
              elsif total_parameters == 2
                # like check_name(name, opts)
                send(check_method, @formatted_params_after_default_fields_check[key], @formatted_params_after_default_fields_check)
              end

      @formatted_params_after_custom_fields_check[key] = value
    rescue ParamsChecker::FieldError => e
      @custom_check_errors[key] = e
    end

    def overall_check
      @formatted_params_after_custom_overall_check = check(formatted_params_after_custom_fields_check)
    end

    def init
      {}
    end

    def check(params)
      params
    end

    def formatted_params
      formatted_params_after_custom_overall_check
    end

    def add_errors
      # only add errors at the outest hash
      # return unless is_outest_hash

      field_errors = errors.each_with_object({}) do |error, hash|
        key, value = error
        value = value.is_a?(Array) ? value[0] : value
        hash[key] = value

        errors.delete(key)
      end

      @custom_check_errors.each do |key, value|
        field_errors[key] = value
      end

      errors.add(
        :errors,
        {
          message: DEFAULT_MESSAGE_ERROR,
          error_type: 'fields_errors',
          field_errors: field_errors,
        }
      )
    end

    attr_accessor :params,
                  :context,
                  :formatted_params_after_default_fields_check,
                  :formatted_params_after_custom_fields_check,
                  :formatted_params_after_custom_overall_check,
                  :is_outest_hash,
                  :message,
                  :custom_check_errors
  end
end

# return true if value_need_to_be_present?(key) && value_present?(key) && value_valid?(key)
# return false if value_need_to_be_present?(key) && value_present?(key) && !value_valid?(key)
# return false if value_need_to_be_present?(key) && !value_present?(key) && value_valid?(key)
# return false if value_need_to_be_present?(key) && !value_present?(key) && !value_valid?(key)
# return true if !value_need_to_be_present?(key) && value_present?(key) && value_valid?(key)
# return false if !value_need_to_be_present?(key) && value_present?(key) && !value_valid?(key)
# return true if !value_need_to_be_present?(key) && !value_present?(key) && value_valid?(key)
# return true if !value_need_to_be_present?(key) && !value_present?(key) && !value_valid?(key)
