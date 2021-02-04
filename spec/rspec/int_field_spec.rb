require 'rails_helper'
require 'validators/int_field'
require 'shared_contexts/base'
require 'helper/base'
# require 'helper/int_field'

# rubocop:disable Metricts/BlockLength
RSpec.describe 'int_field', type: :helper do
  include_context 'error_messages'

  let(:valid_value) { 5 }
  let(:allow_nil_error_message) { "This field's type must be integer." }

  def get_field_error(cmd)
    R_.get(cmd.errors, 'errors[0].field_errors.age')
  end

  def get_value_error_message(min: -2_000_000_000, max: 2_000_000_000)
    "This integer field's value must be in range from #{min} to #{max}."
  end

  describe 'check param_checker arguments' do
    describe 'check type' do
      describe 'check min' do
        context 'type is not integer' do
          let(:validator) { IntField::InvalidMinTypeValidator }

          it 'should RAISE ERROR' do
            expect_raise(validator)
            expect_raise_message(validator, integer_argument_error_message)
          end
        end
      end

      describe 'check max' do
        context 'type is not integer' do
          let(:validator) { IntField::InvalidMaxTypeValidator }

          it 'should RAISE ERROR' do
            expect_raise(validator)
            expect_raise_message(validator, integer_argument_error_message)
          end
        end
      end

      describe 'check required' do
        context 'type is not boolean' do
          let(:validator) { IntField::InvalidRequiredTypeValidator }

          it 'should RAISE ERROR' do
            expect_raise(validator)
            expect_raise_message(validator, boolean_argument_error_message)
          end
        end
      end

      describe 'check allow_nil' do
        context 'type is not boolean' do
          let(:validator) { IntField::InvalidAllowNilTypeValidator }

          it 'should RAISE ERROR' do
            expect_raise(validator)
            expect_raise_message(validator, boolean_argument_error_message)
          end
        end
      end
    end

    describe 'check value' do
      describe 'check min' do
        context 'value is invalid' do
          let(:validator) { IntField::InvalidMinValueValidator }

          it 'should RAISE ERROR' do
            expect_raise(validator)
            expect_raise_message(validator, int_length_error_message)
          end
        end
      end

      describe 'check max' do
        context 'value is invalid' do
          let(:validator) { IntField::InvalidMaxValueValidator }

          it 'should RAISE ERROR' do
            expect_raise(validator)
            expect_raise_message(validator, int_length_error_message)
          end
        end
      end
    end
  end

  describe 'check default param_checker' do
    let(:validator) { IntField::DefaultValidator }

    describe 'check default required parameter' do
      context 'field is absent' do
        it 'should BE PREVENTED' do
          params = {}
          cmd = validator.call(params: params)

          expect_fail(cmd)
          expect_eq(get_field_error(cmd), required_error_message)
        end
      end
    end

    describe 'check default default value parameter' do
      context 'default value is not set' do
        it 'value should NOT BE SET' do
          params = {}
          cmd = validator.call(params: params)

          expect_fail(cmd)
          expect_eq(get_field_error(cmd), required_error_message)
          expect_eq(cmd.result, {})
        end
      end
    end

    describe 'check default min_value parameter' do
      context 'field is too big' do
        it 'should BE PREVENTED' do
          params = {
            age: -2_000_000_001
          }
          cmd = validator.call(params: params)

          expect_fail(cmd)
          expect_eq(get_field_error(cmd), get_value_error_message)
        end
      end
    end

    describe 'check default max_value parameter' do
      context 'field is too big' do
        it 'should BE PREVENTED' do
          params = {
            age: 2_000_000_001
          }
          cmd = validator.call(params: params)

          expect_fail(cmd)
          expect_eq(get_field_error(cmd), get_value_error_message)
        end
      end
    end

    describe 'check default allow_nil parameter' do
      context 'field is nil' do
        it 'should BE PREVENTED' do
          params = { age: nil }
          cmd = validator.call(params: params)

          expect_fail(cmd)
          expect_eq(get_field_error(cmd), allow_nil_error_message)
        end
      end
    end

    describe 'check value' do
      context 'value is not integer' do
        it 'should BE PREVENTED' do
          params = { age: 0.5 }
          cmd = validator.call(params: params)

          expect_fail(cmd)
          expect_eq(get_field_error(cmd), integer_argument_error_message)
        end
      end
    end

    context 'field is valid' do
      it 'should PASS' do
        params = { age: valid_value }
        cmd = validator.call(params: params)

        expect_success(cmd)
      end
    end
  end

  describe 'check params' do
    describe 'check default value parameter' do
      context 'default value is absent' do
        let(:validator) { IntField::DefaultValueIsAbsentValidator }

        context 'field is absent' do
          it 'should BE PREVENTED' do
            params = {}
            cmd = validator.call(params: params)

            expect_fail(cmd)
            expect_eq(get_field_error(cmd), required_error_message)
          end
        end

        context 'field is present' do
          it 'should PASS' do
            params = { age: valid_value }
            cmd = validator.call(params: params)

            expect_eq(cmd.result, { age: valid_value })
          end
        end
      end

      context 'default value is present' do
        let(:validator) { IntField::DefaultValueIsPresentValidator }

        context 'field is absent' do
          it 'value should BE SET' do
            params = {}
            cmd = validator.call(params: params)

            expect_eq(cmd.result, { age: 3 })
          end
        end

        context 'field is present' do
          it 'value should NOT BE SET' do
            params = { age: valid_value }
            cmd = validator.call(params: params)

            expect_eq(cmd.result, { age: valid_value })
          end
        end
      end
    end

    describe 'check required parameter' do
      context 'required parameter is true' do
        let(:validator) { IntField::RequiredValidator }

        context 'field is absent' do
          it 'should BE PREVENTED' do
            params = {}
            cmd = validator.call(params: params)

            expect_fail(cmd)
            expect_eq(get_field_error(cmd), required_error_message)
          end
        end

        context 'field is present' do
          it 'should PASS' do
            params = { age: valid_value }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end
      end

      context 'required parameter is false' do
        let(:validator) { IntField::NotRequiredValidator }

        context 'field is absent' do
          it 'should PASS' do
            params = {}
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end

        context 'field is present' do
          it 'should PASS' do
            params = { age: valid_value }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end
      end
    end

    describe 'check min parameter' do
      describe 'min is 10' do
        let(:validator) { IntField::MinValidator }

        context 'field is too small' do
          it 'should BE PREVENTED' do
            params = { age: 9 }
            cmd = validator.call(params: params)

            expect_fail(cmd)
            expect_eq(get_field_error(cmd), get_value_error_message(min: 10))
          end
        end

        context 'field is not too small' do
          it 'should PASS' do
            params = { age: 10 }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end
      end
    end

    describe 'check max parameter' do
      describe 'max is 9' do
        let(:validator) { IntField::MaxValidator }

        context 'field is too big' do
          it 'should BE PREVENTED' do
            params = { age: 10 }
            cmd = validator.call(params: params)

            expect_fail(cmd)
            expect_eq(get_field_error(cmd), get_value_error_message(max: 9))
          end
        end

        context 'field is not too big' do
          it 'should PASS' do
            params = { age: 9 }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end
      end
    end

    describe 'check allow_nil parameter' do
      context 'allow_nil parameter is true' do
        let(:validator) { IntField::AllowNilValidator }

        context 'field is nil' do
          it 'should PASS' do
            params = { age: nil }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end

        context 'field is not nil' do
          it 'should PASS' do
            params = { age: valid_value }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end
      end

      context 'allow_nil parameter is false' do
        let(:validator) { IntField::NotAllowNilValidator }

        context 'field is nil' do
          it 'should BE PREVENTED' do
            params = { age: nil }
            cmd = validator.call(params: params)

            expect_fail(cmd)
            expect_eq(get_field_error(cmd), allow_nil_error_message)
          end
        end

        context 'field is not nil' do
          it 'should PASS' do
            params = { age: valid_value }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end
      end
    end
  end
end
# rubocop:enable Metricts/BlockLength
