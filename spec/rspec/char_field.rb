require 'rails_helper'
require 'validators/char_field'
require 'shared_contexts/base'
require 'helper/base'
require 'helper/char_field'

# TODO:
# - more tests about default value param

# rubocop:disable Metricts/BlockLength
RSpec.describe 'char_field', type: :helper do
  include_context 'required_error_message'
  include_context 'allow_blank_error_message'
  include_context 'integer_argument_error_message'
  include_context 'numberic_argument_error_message'
  include_context 'boolean_argument_error_message'

  let(:allow_nil_error_message) { "This field's type must be string." }
  let(:char_length_error_message) { 'Invalid char length.' }

  describe 'check param_checker arguments' do
    describe 'check type' do
      describe 'check min_length' do
        context 'type is not integer' do
          it 'should RAISE ERROR' do
            validator = CharField::InvalidMinLengthTypeValidator
            expect_raise(validator)
            expect_raise_message(validator, integer_argument_error_message)
          end
        end
      end

      describe 'check max_length' do
        context 'type is not integer' do
          it 'should RAISE ERROR' do
            validator = CharField::InvalidMaxLengthTypeValidator
            expect_raise(validator)
            expect_raise_message(validator, integer_argument_error_message)
          end
        end
      end

      describe 'check required' do
        context 'type is not boolean' do
          it 'should RAISE ERROR' do
            validator = CharField::InvalidRequiredTypeValidator
            expect_raise(validator)
            expect_raise_message(validator, boolean_argument_error_message)
          end
        end
      end

      describe 'check allow_blank' do
        context 'type is not boolean' do
          it 'should RAISE ERROR' do
            validator = CharField::InvalidAllowBlankTypeValidator
            expect_raise(validator)
            expect_raise_message(validator, boolean_argument_error_message)
          end
        end
      end

      describe 'check allow_nil' do
        context 'type is not boolean' do
          it 'should RAISE ERROR' do
            validator = CharField::InvalidAllowNilTypeValidator
            expect_raise(validator)
            expect_raise_message(validator, boolean_argument_error_message)
          end
        end
      end
    end

    describe 'check value' do
      describe 'check min_length' do
        context 'value is not valid' do
          it 'should RAISE ERROR' do
            validator = CharField::InvalidMinLengthValueValidator
            expect_raise(validator)
            expect_raise_message(validator, char_length_error_message)
          end
        end
      end

      describe 'check max_length' do
        context 'value is not valid' do
          it 'should RAISE ERROR' do
            validator = CharField::InvalidMaxLengthValueValidator
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
          params = { char: '' }
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

          expect_eq(cmd.result, {})
        end
      end
    end

    describe 'check default max_value parameter' do
      context 'field is too long' do
        it 'should BE PREVENTED' do
          params = {
            char: '70jqfYkkZsXVagVLUAJMQjTMLC6BJAPzryxjSX1CXri
              IyvIN8iWZjfQ5UYsheouXnTTvmKaVbSmvFOo5naA5QWKeLtR02ngX8VFGqs
              9mouekJqqqICfYJJcSizvDsNfCHNMA26eomvrfry1gLsxCkQ6PagKOrJ266
              BhAutIT6bfeNUE6ywA9gMyz6keUkumB1AYJy7i1BgAarHydqMvNOKKIoCVm
              V5Jg5qw9LVyfgUjeAEivzAdvwSdMKXQ0TGjx'
          }
          cmd = validator.call(params: params)

          expect_fail(cmd)
          expect_eq(get_field_error(cmd), get_max_length_error_message)
        end
      end
    end

    describe 'check default allow_nil parameter' do
      context 'field is nil' do
        it 'should BE PREVENTED' do
          params = { char: nil }
          cmd = validator.call(params: params)

          expect_fail(cmd)
          expect_eq(get_field_error(cmd), allow_nil_error_message)
        end
      end
    end

    context 'field is valid' do
      it 'should PASS' do
        params = { char: 'valid_char' }
        cmd = validator.call(params: params)

        expect_success(cmd)
      end
    end
  end

  describe 'check params' do
    describe 'check default value parameter' do
      let(:validator) { CharField::DefaultValueValidator }

      context 'default value is set' do
        it 'value should BE SET' do
          params = {}
          cmd = validator.call(params: params)

          expect_eq(cmd.result, { char: 'default_char' })
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
            params = { char: 'present_char' }
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
            params = { char: 'present_char' }
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
            params = { char: '' }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end

        context 'field is not blank' do
          it 'should PASS' do
            params = { char: 'not_blank_char' }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end
      end

      context 'allow_blank parameter is false' do
        let(:validator) { CharField::NotAllowBlankValidator }

        context 'field is blank' do
          it 'should BE PREVENTED' do
            params = { char: '' }
            cmd = validator.call(params: params)

            expect_fail(cmd)
            expect_eq(get_field_error(cmd), allow_blank_error_message)
          end
        end

        context 'field is not blank' do
          it 'should PASS' do
            params = { char: 'not_blank_char' }
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
            params = { char: 'length: 9' }
            cmd = validator.call(params: params)

            expect_fail(cmd)
            expect_eq(get_field_error(cmd), get_max_length_error_message(min_length: 10))
          end
        end

        context 'field is long enough' do
          it 'should PASS' do
            params = { char: 'length: 10' }
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
            params = { char: 'length: 10' }
            cmd = validator.call(params: params)

            expect_fail(cmd)
            expect_eq(get_field_error(cmd), get_max_length_error_message(max_length: 9))
          end
        end

        context 'field is short enough' do
          it 'should PASS' do
            params = { char: 'length: 9' }
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
            params = { char: nil }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end

        context 'field is not nil' do
          it 'should PASS' do
            params = { char: 'not_nil_char' }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end
      end

      context 'allow_nil parameter is false' do
        let(:validator) { CharField::NotAllowNilValidator }

        context 'field is nil' do
          it 'should BE PREVENTED' do
            params = { char: nil }
            cmd = validator.call(params: params)

            expect_fail(cmd)
            expect_eq(get_field_error(cmd), allow_nil_error_message)
          end
        end

        context 'field is not nil' do
          it 'should PASS' do
            params = { char: 'not_nil_char' }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end
      end
    end
  end
end
# rubocop:enable Metricts/BlockLength
