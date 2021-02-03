require 'rails_helper'
require 'validators/text_field'
require 'validators/char_field'
require 'helper/base'

# only need to test arguments that is diffirent from the char_field
RSpec.describe 'text_field', type: :helper do
  let(:text_length_error_message) { 'Invalid text length.' }

  def get_field_error(cmd)
    R_.get(cmd.errors, 'errors[0].field_errors.name')
  end

  def get_length_error_message(min_length: 0, max_length: 30_000)
    "This string field's length must be in range from #{min_length} to #{max_length}."
  end

  describe 'check param_checker arguments' do
    describe 'check value' do
      describe 'check max_length' do
        let(:validator) { TextField::InvalidMaxLengthValueValidator }

        context 'value is invalid' do
          it 'should RAISE ERROR' do
            expect_raise(validator)
            expect_raise_message(validator, text_length_error_message)
          end
        end

        context 'value is valid' do
          it 'should RAISE ERROR' do
            expect_not_raise(TextField::ValidMaxLengthValueValidator)
          end
        end
      end
    end
  end

  describe 'check default param_checker' do
    let(:validator) { TextField::DefaultValidator }
    describe 'check default max_value parameter' do
      context 'field is not too long' do
        it 'should PASS' do
          params = { name: 'a' * 256 }

          cmd = validator.call(params: params)

          expect_success(cmd)
        end
      end

      context 'field is too long' do
        it 'should PASS' do
          params = { name: 'a' * 30_001 }

          cmd = validator.call(params: params)

          expect_fail(cmd)
          expect_eq(get_field_error(cmd), get_length_error_message)
        end
      end
    end
  end
end
