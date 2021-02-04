require 'rails_helper'
require 'validators/time_field'
require 'shared_contexts/base'
require 'helper/base'

# rubocop:disable Metricts/BlockLength
RSpec.describe 'time_field', type: :helper do
  include_context 'error_messages'

  let(:valid_value) { '11:00' }
  let(:allow_nil_error_message) { 'Invalid time.' }
  let(:invalid_time_error_message) { 'Invalid time.' }

  def get_field_error(cmd)
    R_.get(cmd.errors, 'errors[0].field_errors.created_at')
  end

  describe 'check param_checker arguments' do
    describe 'check type' do
      describe 'check required' do
        context 'type is not boolean' do
          let(:validator) { TimeField::InvalidRequiredTypeValidator }

          it 'should RAISE ERROR' do
            expect_raise(validator)
            expect_raise_message(validator, boolean_argument_error_message)
          end
        end
      end

      describe 'check allow_nil' do
        context 'type is not boolean' do
          let(:validator) { TimeField::InvalidAllowNilTypeValidator }

          it 'should RAISE ERROR' do
            expect_raise(validator)
            expect_raise_message(validator, boolean_argument_error_message)
          end
        end
      end
    end
  end

  describe 'check default param_checker' do
    let(:validator) { TimeField::DefaultValidator }

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
          params = { created_at: nil }
          cmd = validator.call(params: params)

          expect_fail(cmd)
          expect_eq(get_field_error(cmd), allow_nil_error_message)
        end
      end
    end

    describe 'check value' do
      context 'value is not a valid time format' do
        it 'should BE PREVENTED' do
          params = { created_at: '25:00' }
          cmd = validator.call(params: params)

          expect_fail(cmd)
          expect_eq(get_field_error(cmd), invalid_time_error_message)
        end
      end
    end

    context 'field is valid' do
      it 'should PASS' do
        params = { created_at: valid_value }
        cmd = validator.call(params: params)

        expect_success(cmd)
      end
    end
  end

  describe 'check params' do
    describe 'check default value parameter' do
      context 'default value is absent' do
        let(:validator) { TimeField::DefaultValueIsAbsentValidator }

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
            params = { created_at: valid_value }
            cmd = validator.call(params: params)

            expect_eq(cmd.result, { created_at: Time.parse(valid_value) })
          end
        end
      end

      context 'default value is present' do
        let(:validator) { TimeField::DefaultValueIsPresentValidator }

        context 'field is absent' do
          it 'value should BE SET' do
            params = {}
            cmd = validator.call(params: params)

            expect_eq(cmd.result, { created_at: Time.parse('12:00') })
          end
        end

        context 'field is present' do
          it 'value should NOT BE SET' do
            params = { created_at: valid_value }
            cmd = validator.call(params: params)

            expect_eq(cmd.result, { created_at: Time.parse(valid_value) })
          end
        end
      end
    end

    describe 'check required parameter' do
      context 'required parameter is true' do
        let(:validator) { TimeField::RequiredValidator }

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
            params = { created_at: valid_value }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end
      end

      context 'required parameter is false' do
        let(:validator) { TimeField::NotRequiredValidator }

        context 'field is absent' do
          it 'should PASS' do
            params = {}
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end

        context 'field is present' do
          it 'should PASS' do
            params = { created_at: valid_value }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end
      end
    end

    describe 'check allow_nil parameter' do
      context 'allow_nil parameter is true' do
        let(:validator) { TimeField::AllowNilValidator }

        context 'field is nil' do
          it 'should PASS' do
            params = { created_at: nil }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end

        context 'field is not nil' do
          it 'should PASS' do
            params = { created_at: valid_value }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end
      end

      context 'allow_nil parameter is false' do
        let(:validator) { TimeField::NotAllowNilValidator }

        context 'field is nil' do
          it 'should BE PREVENTED' do
            params = { created_at: nil }
            cmd = validator.call(params: params)

            expect_fail(cmd)
            expect_eq(get_field_error(cmd), allow_nil_error_message)
          end
        end

        context 'field is not nil' do
          it 'should PASS' do
            params = { created_at: valid_value }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end
      end
    end
  end
end
# rubocop:enable Metricts/BlockLength
