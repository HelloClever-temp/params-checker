module ParamsChecker
  class BaseParamsChecker
    include Fields
    prepend SimpleCommand
    def initialize(params: {}, context: {}, is_outest_hash: true)
      @params = params
      @context = context
      @is_outest_hash = is_outest_hash
      @formatted_params_after_default_check = {}
      @formatted_params_after_custom_specify_field_checks = {}
      @formatted_params_after_custom_all_fields_check = {}
    end

    def self.init required: true, many: false 
      raise "This field's type must be boolean." if [required, many].any? { |value| !value.in? [true, false] }

      type = many ? 'nested_hashs' : 'nested_hash'
      {
          type: type,
          required: required,
          many: many,
          class: self
      }
    end

    def raise_error message="Invalid data"
      raise MyError.new(message)
    end

    def call
      default_check && custom_check
      error_exist? && add_error
      formatted_params
    rescue => e
      if e.class.name == 'ParamsChecker::MyError'
          errors.add(:errors, {
              message: e,
              details: {}
          })
      else
          raise e
      end
    end

    def error_exist?
      !errors.empty? && errors.is_a?(Hash)
    end

    def default_check
      all_fields_are_valid = true
      fields.each do |key, value|
              all_fields_are_valid = false unless data_valid? key
      end
      all_fields_are_valid
    end

    def data_valid? key
      if value_need_to_be_present?(key)
        if value_present?(key)
          if value_valid?(key) 
              true
          else
              false
          end
        else
          errors.add(key, 'This field is required.')
          false
        end
      else
        if value_present?(key)
          if value_valid?(key) 
              true
          else    
              false
          end
        else
            true
        end
      end
    end

    def value_need_to_be_present? key
      if fields[key].key?(:default) && !fields[key][:default].nil?
        @params[key] = fields[key][:default]
        true
      else
        fields[key][:required]
      end
    end

    def value_present? key
      params.key?(key)
    end

    def value_valid? key
      cmd = check_base_on_field_type key
      if cmd.success?
          @formatted_params_after_default_check[key] = cmd.result
      else
          errors.add(key, cmd.errors[key])
      end
      cmd.success?
    end

    def fields
      field_params = {}
      init.each do |key, field|
          field_params[key] = field
      end
      @fields ||= field_params
    end

    def check_base_on_field_type key
      case fields[key][:type]
      when 'int'
          ParamChecker::IntParamChecker.call key, fields, params
      when 'char'
          ParamChecker::CharParamChecker.call key, fields, params
      when 'text'
          ParamChecker::CharParamChecker.call key, fields, params
      when 'arr'
          ParamChecker::ArrParamChecker.call key, fields, params
      when 'nested_hash'
          ParamChecker::NestedHashChecker.call key, fields, params, context
      when 'nested_hashs'
          ParamChecker::NestedHashsChecker.call key, fields, params, context
      when 'date'
          ParamChecker::DateParamChecker.call key, fields, params
      when 'time'
          ParamChecker::TimeParamChecker.call key, fields, params
      when 'datetime'
          ParamChecker::DateTimeParamChecker.call key, fields, params
      end
    end

    def custom_check
      specify_field_checks && all_fields_check
    end

    def specify_field_checks
      @formatted_params_after_custom_specify_field_checks = formatted_params_after_default_check
      fields.each do |key, value|
          next unless self.methods.grep(/check_#{key}/).length > 0

          specify_field_check key
      end
    end

    def specify_field_check key
      check_method = "check_#{key}"
      value = self.send check_method, params[key]
      @formatted_params_after_custom_specify_field_checks.delete(key)
      @formatted_params_after_custom_specify_field_checks[key] = value
    end

    def all_fields_check
      @formatted_params_after_custom_all_fields_check = check formatted_params_after_custom_specify_field_checks
    end

    def init
      {}
    end

    def check params
      params
    end

    def formatted_params
      formatted_params_after_custom_all_fields_check
    end

    def add_error()
      # only add errors skeleton at the outest hash
      return unless is_outest_hash

      details = {}
      errors.each do |key, value|
          details[key] = value
          errors.delete(key)
      end
      errors.add(:errors, {
          message: 'Invalid data.',
          details: details
      })
    end

    attr_accessor :params, :context,
      :formatted_params_after_default_check,
        :formatted_params_after_custom_specify_field_checks,
        :formatted_params_after_custom_all_fields_check,
        :is_outest_hash
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
