require 'rails_helper'
require 'validators/nested_hash_field'
require 'shared_contexts/base'
require 'helper/base'

# rubocop:disable Metricts/BlockLength
RSpec.describe 'nested_hash_field', type: :helper do
  include_context 'error_messages'

  let(:valid_value) { { name: 'Ted', age: 11 } }

  let(:allow_nil_error_message) { "This field's type must be object or ActionController::Parameters." }
  let(:invalid_hash_error_message) { "This field's type must be object or ActionController::Parameters." }
  let(:required_error_message) { 'This field is required.' }
  let(:invalid_char_error_message) { "This field's type must be string." }
  let(:invalid_integer_error_message) { "This field's type must be integer." }
  let(:invalid_boolean_error_message) { "This field's type must be boolean." }
  let(:invalid_date_error_message) { 'Invalid date.' }

  let(:person_error_path) { 'errors.field_errors.person' }
  let(:age_error_path) { "#{person_error_path}.age" }
  let(:name_error_path) { "#{person_error_path}.name" }

  let(:person1_error_path) { 'errors.field_errors.person1' }
  let(:person2_error_path) { 'errors.field_errors.person1.person2' }
  let(:is_male_error_path) { "#{person2_error_path}.is_male" }
  let(:birth_day_error_path) { "#{person2_error_path}.birth_day" }

  def get_field_error(cmd)
    R_.get(cmd.errors, 'errors.field_errors.person')
  end

  describe 'check param_checker arguments' do
    describe 'check type' do
      describe 'check required' do
        context 'type is not boolean' do
          let(:validator) { NestedHashField::InvalidRequiredTypeValidator }

          it 'should RAISE ERROR' do
            expect_raise(validator)
            expect_raise_message(validator, boolean_argument_error_message)
          end
        end
      end

      describe 'check allow_nil' do
        context 'type is not boolean' do
          let(:validator) { NestedHashField::InvalidAllowNilTypeValidator }

          it 'should RAISE ERROR' do
            expect_raise(validator)
            expect_raise_message(validator, boolean_argument_error_message)
          end
        end
      end

      describe 'check many' do
        context 'type is not boolean' do
          let(:validator) { NestedHashField::InvalidManyTypeValidator }

          it 'should RAISE ERROR' do
            expect_raise(validator)
            expect_raise_message(validator, boolean_argument_error_message)
          end
        end
      end
    end
  end

  describe 'check default param_checker' do
    let(:validator) { NestedHashField::DefaultValidator }

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
        it 'should BE PREVENTED & value should NOT BE SET' do
          params = {}
          cmd = validator.call(params: params)

          expect_fail(cmd)
          expect_eq(get_field_error(cmd), required_error_message)
          expect_eq(cmd.result, {})
        end
      end
    end

    describe 'check default allow_nil parameter' do
      context 'field is nil' do
        it 'should BE PREVENTED' do
          params = { person: nil }
          cmd = validator.call(params: params)

          expect_fail(cmd)
          expect_eq(get_field_error(cmd), allow_nil_error_message)
        end
      end
    end

    describe 'check default many parameter' do
      context 'field is false' do
        it 'should BE PREVENTED' do
          params = { person: valid_value }
          cmd = validator.call(params: params)

          expect(cmd.result).to be_a Hash
        end
      end
    end

    describe 'check value' do
      context 'value is not hash' do
        it 'should BE PREVENTED' do
          params = { person: 'invalid_value' }
          cmd = validator.call(params: params)

          expect_fail(cmd)
          expect_eq(get_field_error(cmd), invalid_hash_error_message)
        end
      end

      context 'value is invalid' do
        context 'lacking age' do
          it 'should BE PREVENTED' do
            params = { person: { name: 'a' } }
            cmd = validator.call(params: params)

            expect_fail(cmd)
            expect_eq(R_.get(cmd.errors, age_error_path), required_error_message)
          end
        end

        context 'lacking name' do
          it 'should BE PREVENTED' do
            params = { person: { age: 3 } }
            cmd = validator.call(params: params)

            expect_fail(cmd)
            expect_eq(R_.get(cmd.errors, name_error_path), required_error_message)
          end
        end

        context 'lacking name & age' do
          it 'should BE PREVENTED' do
            params = { person: {} }
            cmd = validator.call(params: params)

            expect_fail(cmd)
            expect_eq(R_.get(cmd.errors, age_error_path), required_error_message)
            expect_eq(R_.get(cmd.errors, name_error_path), required_error_message)
          end
        end

        context 'invalid age' do
          it 'should BE PREVENTED' do
            params = { person: { name: 333, age: 3 } }
            cmd = validator.call(params: params)
            # binding.pry
            expect_fail(cmd)
            expect_eq(R_.get(cmd.errors, name_error_path), invalid_char_error_message)
          end
        end

        context 'invalid name' do
          it 'should BE PREVENTED' do
            params = { person: { name: 333, age: '3' } }
            cmd = validator.call(params: params)

            expect_fail(cmd)
            expect_eq(R_.get(cmd.errors, age_error_path), invalid_integer_error_message)
          end
        end

        context 'invalid name & age' do
          it 'should BE PREVENTED' do
            params = { person: { name: 333, age: '3' } }
            cmd = validator.call(params: params)

            expect_fail(cmd)
            expect_eq(R_.get(cmd.errors, name_error_path), invalid_char_error_message)
            expect_eq(R_.get(cmd.errors, age_error_path), invalid_integer_error_message)
          end
        end
      end

      describe 'check basic cases' do
        let(:validator) { NestedHashField::BasicMultipleNestedHashValidator }
        context 'lacking person2' do
          it 'should BE PREVENTED' do
            params = {
              person1: {
                name: 'Ted',
                age: 11
              }
            }
            cmd = validator.call(params: params)
            expect_fail(cmd)
            expect_eq(R_.get(cmd.errors,
                             person2_error_path), required_error_message)
          end
        end

        context 'lacking is_male' do
          it 'should BE PREVENTED' do
            params = {
              person1: {
                name: 'Ted',
                age: 11,
                person2: {
                  birth_day: '2020-01-01'
                }
              }
            }
            cmd = validator.call(params: params)

            expect_fail(cmd)
            expect_eq(R_.get(cmd.errors, is_male_error_path), required_error_message)
          end
        end

        context 'lacking birth_day' do
          it 'should BE PREVENTED' do
            params = {
              person1: {
                name: 'Ted',
                age: 11,
                person2: {
                  is_male: true
                }
              }
            }
            cmd = validator.call(params: params)

            expect_fail(cmd)
            expect_eq(R_.get(cmd.errors, birth_day_error_path), required_error_message)
          end
        end

        context 'lacking birth_day & is_male' do
          it 'should BE PREVENTED' do
            params = {
              person1: {
                name: 'Ted',
                age: 11,
                person2: {}
              }
            }
            cmd = validator.call(params: params)

            expect_fail(cmd)
            expect_eq(R_.get(cmd.errors, is_male_error_path), required_error_message)
            expect_eq(R_.get(cmd.errors, birth_day_error_path), required_error_message)
          end
        end

        context 'invalid is_male' do
          it 'should BE PREVENTED' do
            params = {
              person1: {
                name: 'Ted',
                age: 11,
                person2: {
                  birth_day: '2020-01-01',
                  is_male: 'invalid_is_male'
                }
              }
            }
            cmd = validator.call(params: params)

            expect_fail(cmd)
            expect_eq(R_.get(cmd.errors, is_male_error_path), invalid_boolean_error_message)
          end
        end

        context 'invalid birth_day' do
          it 'should BE PREVENTED' do
            params = {
              person1: {
                name: 'Ted',
                age: 11,
                person2: {
                  birth_day: 'invalid_birth_day',
                  is_male: true
                }
              }
            }
            cmd = validator.call(params: params)

            expect_fail(cmd)
            expect_eq(R_.get(cmd.errors, birth_day_error_path), invalid_date_error_message)
          end
        end

        context 'invalid birth_day & is_male' do
          it 'should BE PREVENTED' do
            params = {
              person1: {
                name: 'Ted',
                age: 11,
                person2: {
                  birth_day: 'invalid_birth_day',
                  is_male: 'invalid_birth_day'
                }
              }
            }
            cmd = validator.call(params: params)

            expect_fail(cmd)
            expect_eq(R_.get(cmd.errors, birth_day_error_path), invalid_date_error_message)
            expect_eq(R_.get(cmd.errors, is_male_error_path), invalid_boolean_error_message)
          end
        end
      end
    end

    context 'field is valid' do
      it 'should PASS' do
        params = { person: valid_value }

        cmd = validator.call(params: params)

        expect_success(cmd)
      end
    end
  end

  describe 'check params' do
    describe 'check default value parameter' do
      context 'default value is absent' do
        let(:validator) { NestedHashField::DefaultValueIsAbsentValidator }

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
            params = { person: valid_value }
            cmd = validator.call(params: params)

            expect_eq(cmd.result, { person: valid_value })
          end
        end
      end

      context 'default value is present' do
        let(:validator) { NestedHashField::DefaultValueIsPresentValidator }

        context 'field is absent' do
          it 'value should BE SET' do
            params = {}
            cmd = validator.call(params: params)

            expect_eq(cmd.result, { person: { name: 'Vu', age: 14 } })
          end
        end

        context 'field is present' do
          it 'value should NOT BE SET' do
            params = { person: valid_value }
            cmd = validator.call(params: params)

            expect_eq(cmd.result, { person: valid_value })
          end
        end
      end
    end

    describe 'check required parameter' do
      context 'required parameter is true' do
        let(:validator) { NestedHashField::RequiredValidator }

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
            params = { person: valid_value }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end
      end

      context 'required parameter is false' do
        let(:validator) { NestedHashField::NotRequiredValidator }

        context 'field is absent' do
          it 'should PASS' do
            params = {}
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end

        context 'field is present' do
          it 'should PASS' do
            params = { person: valid_value }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end
      end
    end

    describe 'check allow_nil parameter' do
      context 'allow_nil parameter is true' do
        let(:validator) { NestedHashField::AllowNilValidator }

        context 'field is nil' do
          it 'should PASS' do
            params = { person: nil }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end

        context 'field is not nil' do
          it 'should PASS' do
            params = { person: valid_value }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end
      end

      context 'allow_nil parameter is false' do
        let(:validator) { NestedHashField::NotAllowNilValidator }

        context 'field is nil' do
          it 'should BE PREVENTED' do
            params = { person: nil }
            cmd = validator.call(params: params)

            expect_fail(cmd)
            expect_eq(get_field_error(cmd), allow_nil_error_message)
          end
        end

        context 'field is not nil' do
          it 'should PASS' do
            params = { person: valid_value }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end
      end
    end

    describe 'check many parameter' do
      context 'many parameter is true' do
        let(:validator) { NestedHashField::ManyNestedHashValidator }

        context 'field is not many' do
          it 'should BE PREVENTED' do
            params = { person: valid_value }
            cmd = validator.call(params: params)

            expect_fail(cmd)
          end
        end

        context 'field is many' do
          context 'params are valid' do
            it 'should PASS' do
              params = { person: [valid_value, valid_value] }
              cmd = validator.call(params: params)
              pp "========>cmd.result : ", cmd.result

              expect_success(cmd)
              expect_eq(
                cmd.result,
                params
              )
            end
          end

          context 'params are invalid' do
            it 'should PASS' do
              params = { person: [valid_value, valid_value.except(:name), valid_value.except(:age)] }
              cmd = validator.call(params: params)

              expect_fail(cmd)
              expect_eq(
                get_field_error(cmd),
                [
                  nil,
                  {
                    name: 'This field is required.'
                  },
                  {
                    age: 'This field is required.'
                  }
                ]
              )
            end
          end
        end
      end

      context 'many parameter is false' do
        let(:validator) { NestedHashField::DefaultValidator }

        context 'field is not many' do
          it 'should PASS' do
            params = { person: valid_value }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end

        context 'field is many' do
          it 'should BE PREVENTED' do
            params = { person: [valid_value, valid_value] }
            cmd = validator.call(params: params)

            expect_fail(cmd)
          end
        end
      end
    end
  end

  describe 'check custom validator' do
    describe 'format value and return' do
      let(:validator) { NestedHashField::CheckAndFormatFieldsValidator }

      context 'all fields is invalid' do
        it 'should raise general_error error' do
          params = {
            name: 'Ted Nguyen',
            age: 15,
            email: 'ted@rexy.tech'
          }
          cmd = validator.call(params: params)

          expect_success(cmd)

          expect_eq(
            cmd.result,
            {
              name: 'Ted Nguyen Teddy',
              age: 37,
              email: 'ted+11@rexy.tech'
            }
          )
        end
      end
    end

    describe 'check raise_error' do
      let(:validator) { NestedHashField::RaiseErrorValidator }

      context 'all fields is invalid' do
        it 'should raise general_error error' do
          params = {
            name: 'Ted Nguyen',
            age: 15,
            email: 'ted@rexy.tech'
          }
          cmd = validator.call(params: params)

          expect_fail(cmd)
          expect_eq(
            cmd.errors,
            {
              errors: {
                message: 'This name is already exists.',
                error_type: 'general_error'
              }
            }
          )
        end
      end
    end

    describe 'check add_error' do
      let(:validator) { NestedHashField::AddErrorValidator }

      context 'all fields is invalid' do
        it 'should raise fields_errors error' do
          params = {
            name: 'Ted Nguyen',
            age: 15,
            email: 'ted@rexy.tech'
          }
          cmd = validator.call(params: params)

          expect_fail(cmd)
          expect_eq(
            cmd.errors,
            {
              errors: {
                message: 'Fields are not valid',
                error_type: 'fields_errors',
                field_errors: {
                  name: 'This name is already exists.',
                  age: 'You must be older than 18 years old.',
                  email: 'This email is already exists.'
                }
              }
            }
          )
        end
      end
    end

    describe 'check raise_error & add_error' do
      let(:validator) { NestedHashField::RaiseErrorAndAddErrorValidator }

      context 'all fields is invalid' do
        it 'should raise general_error error' do
          params = {
            name: 'Ted Nguyen',
            age: 15,
            email: 'ted@rexy.tech'
          }
          cmd = validator.call(params: params)

          expect_fail(cmd)

          expect_eq(
            cmd.errors,
            {
              errors: {
                message: 'This email is already exists.',
                error_type: 'general_error'
              }
            }
          )
        end
      end
    end
  end
end
# rubocop:enable Metricts/BlockLength
