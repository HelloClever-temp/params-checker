# frozen_string_literal: true

module ParamsChecker
  module ParamChecker
    class BaseParamChecker
      def initialize(key = '', schema = {}, params = {})
        @key = key
        @schema = schema
        @params = params
      end

      def call; end

      def add_field_error(message = '')
        errors.add(key, message)
      end

      attr_accessor :key, :schema, :params
    end

    class NumParamChecker < BaseParamChecker
      prepend SimpleCommand

      def call
        return nil if schema[key][:allow_nil] && params[key].nil?

        check_type && check_param
        params[key]
      end

      def check_type
        valid = params[key].is_a? Numeric
        add_field_error("This field's type must be numeric.") unless valid
        valid
      end

      def check_param
        min = schema[key][:min]
        max = schema[key][:max]
        valid = (min..max).include? params[key]
        add_field_error("This numeric field's value must be in range from #{min} to #{max}.") unless valid
        valid
      end
    end

    class IntParamChecker < BaseParamChecker
      prepend SimpleCommand

      def call
        return nil if schema[key][:allow_nil] && params[key].nil?

        check_type && check_param
        params[key]
      end

      def check_type
        valid = params[key].is_a? Integer
        add_field_error("This field's type must be integer.") unless valid
        valid
      end

      def check_param
        min = schema[key][:min]
        max = schema[key][:max]
        valid = (min..max).include? params[key]
        add_field_error("This integer field's value must be in range from #{min} to #{max}.") unless valid
        valid
      end
    end

    class CharParamChecker < BaseParamChecker
      prepend SimpleCommand

      def call
        return nil if schema[key][:allow_nil] && params[key].nil?

        check_type && check_allow_blank && check_length && params[key]
      end

      def check_type
        valid = params[key].is_a?(String)
        add_field_error("This field's type must be string.") unless valid
        valid
      end

      def check_allow_blank
        valid = !(!schema[key][:allow_blank] && params[key].blank?)
        add_field_error('This field cannot be blank.') unless valid
        valid
      end

      def check_length
        min_length = schema[key][:min_length]
        max_length = schema[key][:max_length]
        valid = (min_length..max_length).include? params[key].length
        add_field_error("This string field's length must be in range from #{min_length} to #{max_length}.") unless valid
        valid
      end
    end

    class ArrParamChecker < BaseParamChecker
      prepend SimpleCommand

      def call
        return nil if schema[key][:allow_nil] && params[key].nil?

        check_type && check_allow_empty && params[key]
      end

      def check_type
        valid = params[key].is_a? Array
        add_field_error("This field's type must be array.") unless valid
        valid
      end

      def check_allow_empty
        valid = !(!schema[key][:allow_empty] && params[key].empty?)
        add_field_error('This field cannot be empty.') unless valid
        valid
      end
    end

    class HashParamChecker < BaseParamChecker
      prepend SimpleCommand

      def call
        return nil if schema[key][:allow_nil] && params[key].nil?

        check_type && params[key]
      end

      def check_type
        valid = params[key].is_a? Hash
        add_field_error("This field's type must be hash.") unless valid
        valid
      end
    end

    class NestedHashChecker
      prepend SimpleCommand
      def initialize(key = '', schema = {}, params = {}, context = {})
        @key = key
        @schema = schema
        @params = params
        @context = context
      end

      def call
        return nil if schema[key][:allow_nil] && params[key].nil?

        check_type && formatted_nested_hash
      end

      def formatted_nested_hash
        cmd = schema[key][:class].call(params: params[key], context: context, is_outest_hash: false)
        return cmd.result if cmd.success?

        add_nested_hash_error(cmd.errors)
      end

      def check_type
        valid = params[key].is_a?(ActionController::Parameters) || params[key].is_a?(Hash)
        add_field_error("This field's type must be object or ActionController::Parameters.") unless valid

        valid
      end

      def add_nested_hash_error(message = '')
        errors.add(key, message[:errors][0][:field_errors])
      end

      def add_field_error(message = '')
        errors.add(key, message)
      end

      attr_accessor :key, :schema, :params, :class, :context
    end

    class NestedHashsChecker
      prepend SimpleCommand
      def initialize(key = '', schema = {}, params = {}, context = {})
        @key = key
        @schema = schema
        @params = params
        @context = context
      end

      def call
        return nil if schema[key][:allow_nil] && params[key].nil?

        check_type && formatted_nested_hashs
      end

      def formatted_nested_hashs
        params[key].map.with_index do |nested_hash, index|
          formatted_nested_hash(nested_hash, index)
        end
      end

      def formatted_nested_hash(nested_hash, index)
        cmd = schema[key][:class].call(
          params: nested_hash,
          context: context,
          is_outest_hash: false
        )
        return cmd.result if cmd.success?

        add_nested_hash_error(cmd.errors, index)
      end

      def check_type
        valid = params[key].is_a?(Array)
        add_field_error("This field's type must be array.") unless valid
        valid
      end

      def add_nested_hash_error(message = '', index)
        errors.add(key, message[:errors][0][:field_errors].merge(index: index))
      end

      def add_field_error(message = '')
        errors.add(key, message)
      end

      attr_accessor :key, :schema, :params, :class, :context
    end

    class DateParamChecker < BaseParamChecker
      prepend SimpleCommand

      def call
        return nil if schema[key][:allow_nil] && params[key].nil?

        formatted_date
      end

      def formatted_date
        Date.parse params[key]
      rescue => e
        add_field_error('Invalid date.')
      end
    end

    class TimeParamChecker < BaseParamChecker
      prepend SimpleCommand

      def call
        return nil if schema[key][:allow_nil] && params[key].nil?

        formatted_time
      end

      def formatted_time
        Time.parse params[key]
      rescue => e
        add_field_error('Invalid time.')
      end
    end

    class DateTimeParamChecker < BaseParamChecker
      prepend SimpleCommand

      def call
        return nil if schema[key][:allow_nil] && params[key].nil?

        formatted_datetime
      end

      def formatted_datetime
        DateTime.parse(params[key])
      rescue => e
        add_field_error('Invalid datetime.')
      end
    end

    class BooleanChecker < BaseParamChecker
      prepend SimpleCommand

      def call
        return nil if schema[key][:allow_nil] && params[key].nil?

        check_type && formatted_boolean
      end

      def formatted_boolean
        [false, "false", "1"].exclude?(opts[:key])
      end

      def check_type
        valid = params[key].in? [true, false, "true", "false", "1", "0"]
        add_field_error("This field's type must be boolean.") unless valid
        valid
      end
    end

    class FileChecker < BaseParamChecker
      prepend SimpleCommand

      def call
        return nil if schema[key][:allow_nil] && params[key].nil?

        check_type && params[key]
      end

      def check_type
        valid = params[key].is_a?(ActionDispatch::Http::UploadedFile)
        add_field_error("This field's type must be file.") unless valid
        valid
      end
    end
  end
end
