require 'rails_helper'
require 'validators/synthetic_testing'
require 'shared_contexts/base'
require 'helper/base'

# rubocop:disable Metricts/BlockLength
RSpec.describe 'synthetic_testing', type: :helper do
  include_context 'error_messages'

  let(:valid_value) do
    {
      example_boolean_field: false,
      example_date_field: '2020-01-01',
      example_arr_field: ['some array element'],
      example_char_field: 'some_string',
      example_hash_field: {
        money: 2_000_000_000_000,
        birth_time: '12:00'
      },
      example_text_field: 'a' * 256,
      example_num_field: -1_000_000_000.5,
      example_bignum_field: -1_000_000_000_000.5,
      example_int_field: -1_000_000_000,
      example_bigint_field: -2_000_000_000_000,
      example_positive_bignum_field: 1_000_000_000_000.5,
      example_positive_num_field: 1_000_000_000.5,
      example_positive_bigint_field: 2_000_000_000_000,
      example_positive_int_field: 2_000_000_000,
      example_time_field: '11:00',
      example_datetime_field: '2020-01-02'
    }
  end
  let(:allow_nil_error_message) { "This field's type must be object or ActionController::Parameters." }
  let(:invalid_hash_error_message) { "This field's type must be object or ActionController::Parameters." }
  let(:required_error_message) { 'This field is required.' }
  let(:invalid_char_error_message) { "This field's type must be string." }
  let(:invalid_integer_error_message) { "This field's type must be integer." }
  let(:invalid_boolean_error_message) { "This field's type must be boolean." }
  let(:invalid_date_error_message) { 'Invalid date.' }

  let(:person_error_path) { 'errors.field_errors.person' }

  def get_valid_value(key)
    # rudash bug when get false boolean values(get true => true, get false => nil)
    return valid_value[:example_boolean_field] if key.to_s == 'example_boolean_field'

    R_.get(valid_value, key)
  end

  describe 'check default param_checker' do
    let(:validator) { Synthetic::DefaultValidator }

    describe 'check required(default is true)' do
      context 'lacking all fields' do
        it 'should BE PREVENTED' do
          params = {
            person: {}
          }
          cmd = validator.call(params: params)

          expect_fail(cmd)
          expect_eq(
            R_.get(cmd.errors, 'errors.field_errors.person'),
            {
              example_boolean_field: required_error_message,
              example_date_field: required_error_message,
              example_text_field: required_error_message,
              example_char_field: required_error_message,
              example_num_field: required_error_message,
              example_bignum_field: required_error_message,
              example_bigint_field: required_error_message,
              example_int_field: required_error_message,
              example_positive_bignum_field: required_error_message,
              example_positive_num_field: required_error_message,
              example_positive_bigint_field: required_error_message,
              example_positive_int_field: required_error_message,
              example_arr_field: required_error_message,
              example_hash_field: required_error_message,
              example_time_field: required_error_message,
              example_datetime_field: required_error_message
            }
          )
        end
      end

      context 'lacking some fields' do
        it 'should BE PREVENTED' do
          params = {
            person: {
              example_boolean_field: get_valid_value('example_boolean_field'),
              example_date_field: get_valid_value('example_date_field'),
              example_arr_field: get_valid_value('example_arr_field'),
              example_char_field: get_valid_value('example_char_field'),
              example_hash_field: {
                money: get_valid_value('example_hash_field.money')
              }
            }
          }
          cmd = validator.call(params: params)

          expect_fail(cmd)
          expect_eq(
            R_.get(cmd.errors, 'errors.field_errors.person'),
            {
              example_text_field: required_error_message,
              example_num_field: required_error_message,
              example_bignum_field: required_error_message,
              example_bigint_field: required_error_message,
              example_int_field: required_error_message,
              example_positive_bignum_field: required_error_message,
              example_positive_num_field: required_error_message,
              example_positive_bigint_field: required_error_message,
              example_positive_int_field: required_error_message,
              example_time_field: required_error_message,
              example_datetime_field: required_error_message,
              example_hash_field: {
                birth_time: required_error_message
              }
            }
          )
        end
      end

      context 'not lacking any fields' do
        it 'should PASS' do
          params = {
            person: valid_value
          }
          cmd = validator.call(params: params)

          expect_success(cmd)
        end
      end
    end

    describe 'check default value(default is nil)' do
      it 'should not set default values & should BE PREVENTED' do
        params = {
          person: {}
        }
        cmd = validator.call(params: params)

        expect_fail(cmd)
        expect_eq(
          R_.get(cmd.errors, 'errors.field_errors.person'),
          {
            example_boolean_field: required_error_message,
            example_date_field: required_error_message,
            example_text_field: required_error_message,
            example_char_field: required_error_message,
            example_num_field: required_error_message,
            example_bignum_field: required_error_message,
            example_bigint_field: required_error_message,
            example_int_field: required_error_message,
            example_positive_bignum_field: required_error_message,
            example_positive_num_field: required_error_message,
            example_positive_bigint_field: required_error_message,
            example_positive_int_field: required_error_message,
            example_arr_field: required_error_message,
            example_hash_field: required_error_message,
            example_time_field: required_error_message,
            example_datetime_field: required_error_message
          }
        )
      end
    end

    describe 'check allow_blank(default is false)' do
      context 'char_field is blank' do
        it 'should BE PREVENTED' do
          params = {
            person: valid_value.merge(
              example_char_field: ''
            )
          }
          cmd = validator.call(params: params)

          expect_fail(cmd)
          expect_eq(
            R_.get(cmd.errors, 'errors.field_errors.person'),
            {
              example_char_field: allow_blank_error_message
            }
          )
        end
      end

      context 'text_field is blank' do
        it 'should BE PREVENTED' do
          params = {
            person: valid_value.merge(
              example_text_field: ''
            )
          }
          cmd = validator.call(params: params)

          expect_fail(cmd)
          expect_eq(
            R_.get(cmd.errors, 'errors.field_errors.person'),
            {
              example_text_field: allow_blank_error_message
            }
          )
        end
      end

      context 'char_field & text_field are blank' do
        it 'should BE PREVENTED' do
          params = {
            person: valid_value.merge(
              example_char_field: '',
              example_text_field: ''
            )
          }
          cmd = validator.call(params: params)

          expect_fail(cmd)
          expect_eq(
            R_.get(cmd.errors, 'errors.field_errors.person'),
            {
              example_char_field: allow_blank_error_message,
              example_text_field: allow_blank_error_message
            }
          )
        end
      end
    end

    describe 'check allow_nil(default is false)' do
      context 'all fields are nil' do
        it 'should BE PREVENTED' do
          all_nil_fields = valid_value.transform_values { |_| nil }

          params = {
            person: all_nil_fields
          }
          cmd = validator.call(params: params)

          expect_fail(cmd)
        end
      end

      context 'some fields are nil' do
        it 'should BE PREVENTED' do
          params = {
            person: valid_value.merge(
              example_char_field: nil,
              example_text_field: nil
            )
          }
          cmd = validator.call(params: params)

          expect_fail(cmd)
        end
      end
    end

    describe 'check allow_empty(default is false)' do
      context 'array is empty' do
        it 'should BE PREVENTED' do
          params = {
            person: valid_value.merge(example_arr_field: [])
          }
          cmd = validator.call(params: params)

          expect_fail(cmd)
          expect_eq(
            R_.get(cmd.errors, 'errors.field_errors.person'),
            {
              example_arr_field: 'This field cannot be empty.'
            }
          )
        end
      end
    end

    describe 'check min' do
      context 'all fields are too small' do
        it 'should BE PREVENTED' do
          params = {
            person: valid_value.merge(
              example_int_field: -2_000_000_001,
              example_num_field: -2_000_000_001,
              example_positive_int_field: -1,
              example_positive_num_field: -1,
              example_bignum_field: -2_000_000_000_001,
              example_bigint_field: -2_000_000_000_001,
              example_positive_bignum_field: -1,
              example_positive_bigint_field: -1
            )
          }
          cmd = validator.call(params: params)

          expect_fail(cmd)
        end
      end

      context 'some fields are too small' do
        it 'should BE PREVENTED' do
          params = {
            person: valid_value.merge(
              example_int_field: -2_000_000_001,
              example_positive_num_field: -1,
              example_bigint_field: -2_000_000_000_001,
              example_positive_bigint_field: -1
            )
          }
          cmd = validator.call(params: params)

          expect_fail(cmd)
        end
      end
    end

    describe 'check max' do
      context 'all fields are too big' do
        it 'should BE PREVENTED' do
          params = {
            person: valid_value.merge(
              example_int_field: 2_000_000_001,
              example_num_field: 2_000_000_001,
              example_positive_int_field: 2_000_000_001,
              example_positive_num_field: 2_000_000_001,
              example_bignum_field: 2_000_000_000_001,
              example_bigint_field: 2_000_000_000_001,
              example_positive_bignum_field: 2_000_000_000_001,
              example_positive_bigint_field: 2_000_000_000_001
            )
          }
          cmd = validator.call(params: params)

          expect_fail(cmd)
        end
      end

      context 'some fields are too big' do
        it 'should BE PREVENTED' do
          params = {
            person: valid_value.merge(
              example_int_field: 2_000_000_001,
              example_positive_num_field: 2_000_000_001,
              example_bigint_field: 2_000_000_000_001,
              example_positive_bigint_field: 2_000_000_000_001
            )
          }
          cmd = validator.call(params: params)

          expect_fail(cmd)
        end
      end
    end

    # can not have a string that length is less than 0, no need to test
    # describe 'check min_length(default is 0)' do
    # end

    describe 'check max_length' do
      context 'char_field is too long' do
        it 'should BE PREVENTED' do
          params = {
            person: valid_value.merge(
              example_char_field: 'a' * 256
            )
          }
          cmd = validator.call(params: params)

          expect_fail(cmd)
          expect_eq(
            R_.get(cmd.errors, 'errors.field_errors.person'),
            {
              example_char_field: "This string field's length must be in range from 0 to 255."
            }
          )
        end
      end

      context 'text_field is too long' do
        it 'should BE PREVENTED' do
          params = {
            person: valid_value.merge(
              example_text_field: 'a' * 30_001
            )
          }
          cmd = validator.call(params: params)

          expect_fail(cmd)
          expect_eq(
            R_.get(cmd.errors, 'errors.field_errors.person'),
            {
              example_text_field: "This string field's length must be in range from 0 to 30000."
            }
          )
        end
      end

      context 'char_field & text_field are too long' do
        it 'should BE PREVENTED' do
          params = {
            person: valid_value.merge(
              example_char_field: 'a' * 256,
              example_text_field: 'a' * 30_001
            )
          }
          cmd = validator.call(params: params)

          expect_fail(cmd)
          expect_eq(
            R_.get(cmd.errors, 'errors.field_errors.person'),
            {
              example_char_field: "This string field's length must be in range from 0 to 255.",
              example_text_field: "This string field's length must be in range from 0 to 30000."
            }
          )
        end
      end
    end
  end

  describe 'check some random params' do
    let(:validator) { Synthetic::DefaultValidator }

    context 'params are invalid' do
      describe 'check invalid params 1' do
        it 'should BE PREVENTED' do
          params = {
            person: valid_value.merge(
              example_date_field: 20,
              example_char_field: 'required_error_message',
              example_bigint_field: true,
              example_positive_bignum_field: ['required_error_message'],
              example_positive_num_field: {},
              example_arr_field: 20.3,
              example_hash_field: '13:00'
            )
          }
          cmd = validator.call(params: params)

          expect_fail(cmd)

          expect_eq(
            R_.get(cmd.errors, 'errors.field_errors.person'),
            {
              example_date_field: 'Invalid date.',
              example_bigint_field: "This field's type must be integer.",
              example_positive_bignum_field: "This field's type must be numeric.",
              example_positive_num_field: "This field's type must be numeric.",
              example_arr_field: "This field's type must be array.",
              example_hash_field: "This field's type must be object or ActionController::Parameters."
            }
          )
        end
      end

      describe 'check invalid params 2' do
        it 'should BE PREVENTED' do
          params = {
            person: valid_value.merge(
              example_boolean_field: true,
              example_arr_field: 'a',
              example_hash_field: {
                money: 2_000_000_000_000_000,
                birth_time: '26:00'
              },
              example_num_field: -1_000_000_000_000.5,
              example_bignum_field: true,
              example_bigint_field: -2_000_000_000_000.5,
              example_positive_bigint_field: -3,
              example_positive_int_field: {},
              example_datetime_field: '2020-15-02'
            )
          }
          cmd = validator.call(params: params)

          expect_fail(cmd)

          expect_eq(
            R_.get(cmd.errors, 'errors.field_errors.person'),
            {
              example_num_field: "This numeric field's value must be in range from -2000000000 to 2000000000.",
              example_bignum_field: "This field's type must be numeric.",
              example_bigint_field: "This field's type must be integer.",
              example_positive_bigint_field: "This integer field's value must be in range from 0 to 2000000000000.",
              example_positive_int_field: "This field's type must be integer.",
              example_arr_field: "This field's type must be array.",
              example_hash_field: {
                money: "This integer field's value must be in range from -2000000000000 to 2000000000000.",
                birth_time: 'Invalid time.'
              },
              example_datetime_field: 'Invalid datetime.'
            }
          )
        end
      end

      describe 'check invalid params 3' do
        it 'should BE PREVENTED' do
          params = {
            person: valid_value.merge(
              example_boolean_field: nil,
              example_date_field: nil,
              example_hash_field: {
                money: '2_000_000_000_000',
                birth_time: nil
              },
              example_char_field: 'a' * 256,
              example_text_field: '',
              example_positive_bignum_field: -1_000_000_000_000.5,
              example_positive_num_field: -1_000_000_000.5
            )
          }
          cmd = validator.call(params: params)

          expect_fail(cmd)

          expect_eq(
            R_.get(cmd.errors, 'errors.field_errors.person'),
            {
              example_boolean_field: "This field's type must be boolean.",
              example_date_field: 'Invalid date.',
              example_text_field: 'This field cannot be blank.',
              example_char_field: "This string field's length must be in range from 0 to 255.",
              example_positive_bignum_field: "This numeric field's value must be in range from 0 to 2000000000000.",
              example_positive_num_field: "This numeric field's value must be in range from 0 to 2000000000.",
              example_hash_field: {
                money: "This field's type must be integer.",
                birth_time: 'Invalid time.'
              }
            }
          )
        end
      end
    end

    context 'params are valid' do
      describe 'check valid params 1' do
        it 'should PASS' do
          params = {
            person: {
              example_boolean_field: false,
              example_date_field: '2020-01-01',
              example_arr_field: [1, 2, true, 3, 'string'],
              example_char_field: 'ted_nguyen',
              example_hash_field: {
                money: -1_000,
                birth_time: '12:00'
              },
              example_text_field: 'a' * 256,
              example_num_field: -1.5,
              example_bignum_field: -10.5,
              example_int_field: -1,
              example_bigint_field: -2,
              example_positive_bignum_field: 1.5,
              example_positive_num_field: 1.5,
              example_positive_bigint_field: 2,
              example_positive_int_field: 2,
              example_time_field: '5:30',
              example_datetime_field: '2018-06-01'
            }
          }
          cmd = validator.call(params: params)
          expect_success(cmd)
        end
      end

      describe 'check valid params 2' do
        it 'should PASS' do
          params = {
            person: {
              example_boolean_field: true,
              example_date_field: '1000-02-03',
              example_arr_field: ['char', 1, {}, [], true],
              example_char_field: 'rex_huynh',
              example_hash_field: {
                money: -3_000,
                birth_time: '01:00'
              },
              example_text_field: 'a' * 30_000,
              example_num_field: -1.5,
              example_bignum_field: -10.5,
              example_int_field: -1,
              example_bigint_field: -2,
              example_positive_bignum_field: 1.5,
              example_positive_num_field: 1.5,
              example_positive_bigint_field: 2,
              example_positive_int_field: 2,
              example_time_field: '5:30',
              example_datetime_field: '2018-06-01'
            }
          }
          cmd = validator.call(params: params)
          expect_success(cmd)
        end
      end
    end
  end
end
# rubocop:enable Metricts/BlockLength
