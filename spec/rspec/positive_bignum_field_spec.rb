require 'rails_helper'
require 'validators/positive_bignum_field'
require 'shared_contexts/base'
require 'helper/base'

# rubocop:disable Metricts/BlockLength
RSpec.describe 'positive_bignum_field', type: :helper do
  include_context 'error_messages'

  let(:allow_nil_error_message) { "This field's type must be numeric." }

  def get_field_error(cmd)
    R_.get(cmd.errors, 'errors[0].field_errors.age')
  end

  def get_value_error_message(min: 0, max: 2_000_000_000_000)
    "This numeric field's value must be in range from #{min} to #{max}."
  end

  describe 'check param_checker arguments' do
    describe 'check value' do
      describe 'check min' do
        context 'value is invalid' do
          let(:validator) { PositiveBignumField::InvalidMinValueValidator }

          it 'should RAISE ERROR' do
            expect_raise(validator)
            expect_raise_message(validator, num_length_error_message)
          end
        end
      end
    end
  end

  describe 'check default param_checker' do
    let(:validator) { PositiveBignumField::DefaultValidator }

    describe 'check default min_value parameter' do
      context 'field is too small' do
        it 'should BE PREVENTED' do
          params = {
            age: -1.5
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
