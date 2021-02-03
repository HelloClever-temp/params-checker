require 'rails_helper'
require 'validators/text_field'
require 'helper/base'

# only need to test arguments that is diffirent from the char_field
RSpec.describe 'text_field', type: :helper do
  let(:text_length_error_message) { 'Invalid text length.' }

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
end
