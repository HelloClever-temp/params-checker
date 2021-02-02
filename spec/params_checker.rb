require 'rails_helper'
require 'validators/character_field_validators.rb'

def expect_eq(expect, to)
  expect(expect).to(eq(to))
end

def expect_success(cmd)
  expect_eq(cmd.success?, true)
end

def expect_fail(cmd)
  expect_eq(cmd.success?, false)
end

def get_field_error(cmd)
  R_.get(cmd.errors, 'errors[0].field_errors.char')
end

# TODO:
# - more tests about default value param

# rubocop:disable Metricts/BlockLength
RSpec.describe ParamsChecker, type: :helper do
  let(:required_error_message) { 'This field is required.' }
  let(:allow_blank_error_message) { 'This field cannot be blank.' }
  let(:allow_nil_error_message) { "This field's type must be string." }

  describe 'check char_field' do
    describe 'check default char_field' do
      let(:validator) { CharacterFieldValidators::DefaultValidator }
      let(:max_length_error_message) { "This string field's length must be in range from 0 to 255." }

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
            expect_eq(get_field_error(cmd), max_length_error_message)
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

    describe 'check parameters' do
      describe 'check default value parameter' do
        let(:validator) { CharacterFieldValidators::DefaultValueValidator }

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
          let(:validator) { CharacterFieldValidators::RequiredValidator }

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
          let(:validator) { CharacterFieldValidators::NotRequiredValidator }

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
          let(:validator) { CharacterFieldValidators::AllowBlankValidator }

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
          let(:validator) { CharacterFieldValidators::NotAllowBlankValidator }

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
    end
  end
end
# rubocop:enable Metricts/BlockLength
