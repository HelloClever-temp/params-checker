require 'rails_helper'
require 'validators/readme_examples'
require 'shared_contexts/base'
require 'helper/base'

# rubocop:disable Metricts/BlockLength
RSpec.describe 'readme_examples', type: :helper do
  include_context 'error_messages'

  def get_field_error(cmd)
    R_.get(cmd.errors, 'errors.field_errors')
  end

  def get_general_error(cmd)
    R_.get(cmd.errors, 'errors.message')
  end

  describe 'showcase basic usage' do
    let(:validator) { ReadmeExamples::BasicUsageValidator }

    context 'params are invalid' do
      describe 'validate number 1' do
        it 'should BE PREVENTED' do
          params = {}
          cmd = validator.call(params: params)

          expect_fail(cmd)
          expect_eq(
            get_field_error(cmd),
            {
              name: 'This field is required.',
              age: 'This field is required.',
              email: 'This field is required.'
            }
          )
        end
      end

      describe 'validate number 2' do
        it 'should BE PREVENTED' do
          params = {
            name: true,
            email: 'ted@rexy.tech'
          }
          cmd = validator.call(params: params)

          expect_fail(cmd)
          expect_eq(
            get_field_error(cmd),
            {
              name: "This field's type must be string.",
              age: 'This field is required.'
            }
          )
        end
      end

      describe 'validate number 3' do
        it 'should BE PREVENTED' do
          params = {
            name: 'ted nguyen',
            age: 2_000_000_001,
            email: 'a' * 256
          }
          cmd = validator.call(params: params)

          expect_fail(cmd)
          expect_eq(
            get_field_error(cmd),
            {
              age: "This integer field's value must be in range from -2000000000 to 2000000000.",
              email: "This string field's length must be in range from 0 to 255."
            }
          )
        end
      end
    end

    context 'params are valid' do
      describe 'validate number 4' do
        it 'should PASS' do
          params = {
            name: 'ted nguyen',
            age: 23,
            email: 'ted@rexy.tech'
          }
          cmd = validator.call(params: params)

          expect_success(cmd)
        end
      end
    end
  end

  describe 'showcase advanced usage' do
    let(:validator) { ReadmeExamples::AdvancedUsageValidator }

    context 'params are invalid' do
      describe 'validate number 5' do
        it 'should BE PREVENTED' do
          params = {
            name: 'Ted',
            age: 135,
            email: '',
            phone: ''
          }
          cmd = validator.call(params: params)

          expect_fail(cmd)
          expect_eq(
            get_field_error(cmd),
            {
              name: "This string field's length must be in range from 4 to 30.",
              age: "This integer field's value must be in range from -2000000000 to 130.",
              email: 'This field cannot be blank.'
            }
          )
        end
      end
    end

    context 'params are valid' do
      describe 'validate number 6' do
        it 'should PASS' do
          params = {
            name: 'Ted Nguyen',
            age: 23,
            email: 'ted@rexy.tech',
            phone: ''
          }
          cmd = validator.call(params: params)

          expect_success(cmd)
        end
      end
    end
  end

  describe 'showcase custom validate usage' do
    let(:validator) { ReadmeExamples::CustomValidator }

    context 'params are invalid' do
      describe 'validate number 7' do
        it 'should BE PREVENTED' do
          params = {
            name: 'Ted Nguyen',
            age: 17,
            email: 'ted@rexy.tech'
          }
          cmd = validator.call(params: params, context: { is_super_admin: false })
          # binding.pry
          expect_fail(cmd)
          expect_eq(
            get_general_error(cmd),
            'This email is already exists.'
          )
        end
      end

      describe 'validate number 8' do
        it 'should BE PREVENTED' do
          params = {
            name: 'Ted Nguyen',
            age: 17,
            email: 'ted+1@rexy.tech'
          }
          cmd = validator.call(params: params, context: { is_super_admin: false })
          # binding.pry
          expect_fail(cmd)
          expect_eq(
            get_general_error(cmd),
            "You don't have permission to create a user."
          )
        end
      end

      describe 'validate number 9' do
        it 'should BE PREVENTED' do
          params = {
            name: 'Ted Nguyen',
            age: 17,
            email: 'ted+1@rexy.tech'
          }
          cmd = validator.call(params: params, context: { is_super_admin: true })
          # binding.pry
          expect_fail(cmd)
          expect_eq(
            get_field_error(cmd),
            {
              name: 'This name is already exists.',
              age: 'You must be older than 18 years old.'
            }
          )
        end
      end
    end

    context 'params are valid' do
      describe 'validate number 10' do
        it 'should PASS' do
          params = {
            name: 'Teddy Nguyen',
            age: 19,
            email: 'ted+1@rexy.tech'
          }
          cmd = validator.call(params: params, context: { is_super_admin: true })

          expect_success(cmd)
        end
      end
    end
  end
end
# rubocop:enable Metricts/BlockLength
