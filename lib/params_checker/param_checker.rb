# frozen_string_literal: true

module ParamsChecker
    module ParamChecker
        class BaseParamChecker
            def initialize(key = '', fields = {}, opts = {})
                @key = key
                @fields = fields
                @opts = opts
            end
        
            def call; end
        
            def add_error(message = '')
                errors.add(key, message)
            end
        
            attr_accessor :key, :fields, :opts
        end
        
        class IntParamChecker < BaseParamChecker
            prepend SimpleCommand
        
            def call
                check_type && check_param
                opts[key]
            end
        
            def check_type
                add_error("This field's type must be integer.") unless opts[key].is_a? Integer
            end
        
            def check_param
                min = fields[key][:min]
                max = fields[key][:max]
                add_error("This integer field's value must be in range from #{min} to #{max}.") unless (
                    min..max).include? opts[key]
            end
        end
        
        class CharParamChecker < BaseParamChecker
            prepend SimpleCommand
        
            def call
                check_type && check_allow_blank && check_length && opts[key]
            end
        
            def check_type
                valid = opts[key].is_a? String
                add_error("This field's type must be string.") unless valid
                valid
            end
        
            def check_allow_blank
                valid = !(!fields[key][:allow_blank] && opts[key].blank?)
                add_error('This field cannot be blank.') unless valid
                valid
            end
        
            def check_length
                min_length = fields[key][:min_length]
                max_length = fields[key][:max_length]
                valid = (min_length..max_length).include? opts[key].length
                add_error("This string field's length must be in range from #{min_length} to #{max_length}.") unless valid
                valid
            end
        end
        
        class ArrParamChecker < BaseParamChecker
            prepend SimpleCommand
        
            def call
                check_type && check_allow_empty && opts[key]
            end
        
            def check_type
                valid = opts[key].is_a? Array
                add_error("This field's type must be array.") unless valid
                valid
            end
        
            def check_allow_empty
                valid = !(!fields[key][:allow_empty] && opts[key].empty?)
                add_error('This field cannot be empty.') unless valid
                valid
            end
        end

        class NestedHashChecker
            prepend SimpleCommand
            def initialize(key = '', fields = {}, opts = {}, context = {})
                @key = key
                @fields = fields
                @opts = opts
                @context = context
            end
        
            def call
                check_type && formatted_nested_hash
            end

            def formatted_nested_hash
                cmd = fields[key][:class].call(params:opts[key], context: context, is_outest_hash: false)
                if cmd.success?
                    cmd.result
                else
                    add_error cmd.errors
                end
            end

            def check_type
                valid = opts[key].is_a? ActionController::Parameters
                add_error("This field's type must be object.") unless valid
                valid
            end

            def add_error(message = '')
                errors.add(key, message)
            end
        
            attr_accessor :key, :fields, :opts, :class, :context
        end

        class NestedHashsChecker
            prepend SimpleCommand
            def initialize(key = '', fields = {}, opts = {}, context = {})
                @key = key
                @fields = fields
                @opts = opts
                @context = context
            end
        
            def call
                check_type && formatted_nested_hashs
            end

            def formatted_nested_hashs
                opts[key].each_with_index do |nested_hash, index|
                    opts[key][index] = formatted_nested_hash nested_hash
                end
            end

            def formatted_nested_hash nested_hash
                cmd = fields[key][:class].call(params:nested_hash, context: context, is_outest_hash: false)
                if cmd.success?
                    cmd.result
                else
                    add_error cmd.errors
                end
            end

            def check_type
                valid = opts[key].is_a? Array
                add_error("This field's type must be array.") unless valid
                valid
            end
        
            def add_error(message = '')
                errors.add(key, message)
            end
        
            attr_accessor :key, :fields, :opts, :class, :context
        end
                
        class DateParamChecker < BaseParamChecker
            prepend SimpleCommand
        
            def call
                formatted_date
            end
        
            def formatted_date
                Date.parse opts[key]
            rescue => e
                add_error 'Invalid date.'
            end
        end

        class TimeParamChecker < BaseParamChecker
            prepend SimpleCommand
        
            def call
                formatted_time
            end
        
            def formatted_time
                Time.parse opts[key]
            rescue => e
                add_error 'Invalid time.'
            end
        end

        class DateTimeParamChecker < BaseParamChecker
            prepend SimpleCommand
        
            def call
                formatted_datetime
            end
        
            def formatted_datetime
                DateTime.parse(opts[key])
            rescue => e
                add_error 'Invalid datetime.'
            end
        end

        class EmailParamChecker < BaseParamChecker
          prepend SimpleCommand
      
          def call
              check_type && check_regrex && opts[key]
          end
      
          def check_type
              valid = opts[key].is_a? String
              add_error("Invalid email.") unless valid
              valid
          end
      
          def check_regrex
              valid = opts[key].match(URI::MailTo::EMAIL_REGEXP)
              add_error('Invalid email.') unless valid
              valid
          end
      
        end

    end
end

