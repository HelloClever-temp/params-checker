require 'rails_helper'
require 'validators/char_field'
require 'validators/text_field'
require 'shared_contexts/base'
require 'helper/base'
# require 'helper/char_field'

# rubocop:disable Metricts/BlockLength
RSpec.describe 'char_field', type: :helper do
  include_context 'error_messages'

  let(:valid_value) { 'valid_char' }
  let(:allow_nil_error_message) { "This field's type must be string." }
  let(:invalid_char_error_message) { "This field's type must be string." }
  let(:char_length_error_message) { 'Invalid char length.' }

  def get_field_error(cmd)
    R_.get(cmd.errors, 'errors[0].field_errors.name')
  end

  def get_length_error_message(min_length: 0, max_length: 255)
    "This string field's length must be in range from #{min_length} to #{max_length}."
  end

  describe 'check param_checker arguments' do
    describe 'check type' do
      describe 'check min_length' do
        context 'type is not integer' do
          let(:validator) { CharField::InvalidMinLengthTypeValidator }

          it 'should RAISE ERROR' do
            expect_raise(validator)
            expect_raise_message(validator, integer_argument_error_message)
          end
        end
      end

      describe 'check max_length' do
        context 'type is not integer' do
          let(:validator) { CharField::InvalidMaxLengthTypeValidator }

          it 'should RAISE ERROR' do
            expect_raise(validator)
            expect_raise_message(validator, integer_argument_error_message)
          end
        end
      end

      describe 'check required' do
        context 'type is not boolean' do
          let(:validator) { CharField::InvalidRequiredTypeValidator }

          it 'should RAISE ERROR' do
            expect_raise(validator)
            expect_raise_message(validator, boolean_argument_error_message)
          end
        end
      end

      describe 'check allow_blank' do
        context 'type is not boolean' do
          let(:validator) { CharField::InvalidAllowBlankTypeValidator }

          it 'should RAISE ERROR' do
            expect_raise(validator)
            expect_raise_message(validator, boolean_argument_error_message)
          end
        end
      end

      describe 'check allow_nil' do
        context 'type is not boolean' do
          let(:validator) { CharField::InvalidAllowNilTypeValidator }

          it 'should RAISE ERROR' do
            expect_raise(validator)
            expect_raise_message(validator, boolean_argument_error_message)
          end
        end
      end
    end

    describe 'check value' do
      describe 'check min_length' do
        context 'value is invalid' do
          let(:validator) { CharField::InvalidMinLengthValueValidator }

          it 'should RAISE ERROR' do
            expect_raise(validator)
            expect_raise_message(validator, char_length_error_message)
          end
        end
      end

      describe 'check max_length' do
        context 'value is invalid' do
          let(:validator) { CharField::InvalidMaxLengthValueValidator }

          it 'should RAISE ERROR' do
            expect_raise(validator)
            expect_raise_message(validator, char_length_error_message)
          end
        end
      end
    end
  end

  describe 'check default param_checker' do
    let(:validator) { CharField::DefaultValidator }

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

    describe 'check default allow_blank parameter' do
      context 'field is blank' do
        it 'should BE PREVENTED' do
          params = { name: '' }
          cmd = validator.call(params: params)

          expect_fail(cmd)
          expect_eq(get_field_error(cmd), allow_blank_error_message)
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

    describe 'check default max_value parameter' do
      context 'field is too long' do
        it 'should BE PREVENTED' do
          params = { name: 'a' * 256 }
          cmd = validator.call(params: params)

          expect_fail(cmd)
          expect_eq(get_field_error(cmd), get_length_error_message)
        end
      end
    end

    describe 'check default allow_nil parameter' do
      context 'field is nil' do
        it 'should BE PREVENTED' do
          params = { name: nil }
          cmd = validator.call(params: params)

          expect_fail(cmd)
          expect_eq(get_field_error(cmd), allow_nil_error_message)
        end
      end
    end

    describe 'check value' do
      context 'value is not char' do
        it 'should BE PREVENTED' do
          params = { name: 1 }
          cmd = validator.call(params: params)

          expect_fail(cmd)
          expect_eq(get_field_error(cmd), invalid_char_error_message)
        end
      end
    end

    context 'field is valid' do
      it 'should PASS' do
        params = { name: valid_value }
        cmd = validator.call(params: params)

        expect_success(cmd)
      end
    end
  end

  describe 'check params' do
    describe 'check default value parameter' do
      context 'default value is absent' do
        let(:validator) { CharField::DefaultValueIsAbsentValidator }

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
            params = { name: valid_value }
            cmd = validator.call(params: params)

            expect_eq(cmd.result, { name: valid_value })
          end
        end
      end

      context 'default value is present' do
        let(:validator) { CharField::DefaultValueIsPresentValidator }

        context 'field is absent' do
          it 'value should BE SET' do
            params = {}
            cmd = validator.call(params: params)

            expect_eq(cmd.result, { name: 'default_char' })
          end
        end

        context 'field is present' do
          it 'value should NOT BE SET' do
            params = { name: valid_value }
            cmd = validator.call(params: params)

            expect_eq(cmd.result, { name: valid_value })
          end
        end
      end
    end

    describe 'check required parameter' do
      context 'required parameter is true' do
        let(:validator) { CharField::RequiredValidator }

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
            params = { name: valid_value }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end
      end

      context 'required parameter is false' do
        let(:validator) { CharField::NotRequiredValidator }

        context 'field is absent' do
          it 'should PASS' do
            params = {}
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end

        context 'field is present' do
          it 'should PASS' do
            params = { name: valid_value }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end
      end
    end

    describe 'check allow_blank parameter' do
      context 'allow_blank parameter is true' do
        let(:validator) { CharField::AllowBlankValidator }

        context 'field is blank' do
          it 'should PASS' do
            params = { name: '' }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end

        context 'field is not blank' do
          it 'should PASS' do
            params = { name: valid_value }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end
      end

      context 'allow_blank parameter is false' do
        let(:validator) { CharField::NotAllowBlankValidator }

        context 'field is blank' do
          it 'should BE PREVENTED' do
            params = { name: '' }
            cmd = validator.call(params: params)

            expect_fail(cmd)
            expect_eq(get_field_error(cmd), allow_blank_error_message)
          end
        end

        context 'field is not blank' do
          it 'should PASS' do
            params = { name: valid_value }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end
      end
    end

    describe 'check min_length parameter' do
      describe 'min_length is 10' do
        let(:validator) { CharField::MinLengthValidator }

        context 'field is too short' do
          it 'should BE PREVENTED' do
            params = { name: 'length: 9' }
            cmd = validator.call(params: params)

            expect_fail(cmd)
            expect_eq(get_field_error(cmd), get_length_error_message(min_length: 10))
          end
        end

        context 'field is not too short' do
          it 'should PASS' do
            params = { name: 'length: 10' }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end
      end
    end

    describe 'check max_length parameter' do
      describe 'max_length is 9' do
        let(:validator) { CharField::MaxLengthValidator }

        context 'field is too long' do
          it 'should BE PREVENTED' do
            params = { name: 'length: 10' }
            cmd = validator.call(params: params)

            expect_fail(cmd)
            expect_eq(get_field_error(cmd), get_length_error_message(max_length: 9))
          end
        end

        context 'field is not too long' do
          it 'should PASS' do
            params = { name: 'length: 9' }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end
      end
    end

    describe 'check allow_nil parameter' do
      context 'allow_nil parameter is true' do
        let(:validator) { CharField::AllowNilValidator }

        context 'field is nil' do
          it 'should PASS' do
            params = { name: nil }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end

        context 'field is not nil' do
          it 'should PASS' do
            params = { name: valid_value }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end
      end

      context 'allow_nil parameter is false' do
        let(:validator) { CharField::NotAllowNilValidator }

        context 'field is nil' do
          it 'should BE PREVENTED' do
            params = { name: nil }
            cmd = validator.call(params: params)

            expect_fail(cmd)
            expect_eq(get_field_error(cmd), allow_nil_error_message)
          end
        end

        context 'field is not nil' do
          it 'should PASS' do
            params = { name: valid_value }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end
      end
    end
  end
end
# rubocop:enable Metricts/BlockLength
