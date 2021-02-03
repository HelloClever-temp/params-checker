require 'rails_helper'
require 'validators/bigint_field'
require 'shared_contexts/base'
require 'helper/base'

# rubocop:disable Metricts/BlockLength
RSpec.describe 'bigint_field', type: :helper do
  let(:allow_nil_error_message) { "This field's type must be integer." }
  let(:int_length_error_message) { 'Invalid integer value.' }

  def get_field_error(cmd)
    R_.get(cmd.errors, 'errors[0].field_errors.age')
  end

  def get_value_error_message(min: -2_000_000_000_000, max: 2_000_000_000_000)
    "This integer field's value must be in range from #{min} to #{max}."
  end

  describe 'check param_checker arguments' do
    describe 'check value' do
      describe 'check min' do
        context 'value is invalid' do
          let(:validator) { BigintField::InvalidMinValueValidator }

          it 'should RAISE ERROR' do
            expect_raise(validator)
            expect_raise_message(validator, int_length_error_message)
          end
        end

        context 'value is valid' do
          let(:validator) { BigintField::ValidMinValueValidator }

          it 'should PASS' do
            expect_not_raise(validator)
          end
        end
      end

      describe 'check max' do
        context 'value is invalid' do
          let(:validator) { BigintField::InvalidMaxValueValidator }

          it 'should RAISE ERROR' do
            expect_raise(validator)
            expect_raise_message(validator, int_length_error_message)
          end
        end

        context 'value is valid' do
          let(:validator) { BigintField::ValidMaxValueValidator }

          it 'should PASS' do
            expect_not_raise(validator)
          end
        end
      end
    end
  end

  describe 'check default param_checker' do
    let(:validator) { BigintField::DefaultValidator }

    describe 'check default max_value parameter' do
      context 'field is not too big' do
        it 'should PASS' do
          params = {
            age: 2_000_000_001
          }
          cmd = validator.call(params: params)

          expect_success(cmd)
        end
      end

      context 'field is too big' do
        it 'should BE PREVENTED' do
          params = {
            age: 2_000_000_000_001
          }
          cmd = validator.call(params: params)

          expect_fail(cmd)
          expect_eq(get_field_error(cmd), get_value_error_message)
        end
      end
    end

    describe 'check default min_value parameter' do
      context 'field is not too small' do
        it 'should PASS' do
          params = {
            age: -2_000_000_001
          }
          cmd = validator.call(params: params)

          expect_success(cmd)
        end
      end

      context 'field is too small' do
        it 'should BE PREVENTED' do
          params = {
            age: -2_000_000_000_001
          }
          cmd = validator.call(params: params)

          expect_fail(cmd)
          expect_eq(get_field_error(cmd), get_value_error_message)
        end
      end
    end
  end
end
# rubocop:enable Metricts/BlockLength
