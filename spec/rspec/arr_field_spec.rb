require 'rails_helper'
require 'validators/arr_field'
require 'shared_contexts/base'
require 'helper/base'

# rubocop:disable Metricts/BlockLength
RSpec.describe 'arr_field', type: :helper do
  include_context 'error_messages'

  let(:allow_nil_error_message) { "This field's type must be array." }
  let(:allow_empty_error_message) { 'This field cannot be empty.' }

  def get_field_error(cmd)
    R_.get(cmd.errors, 'errors[0].field_errors.books')
  end

  describe 'check param_checker arguments' do
    describe 'check type' do
      describe 'check required' do
        context 'type is not boolean' do
          let(:validator) { ArrField::InvalidRequiredTypeValidator }

          it 'should RAISE ERROR' do
            expect_raise(validator)
            expect_raise_message(validator, boolean_argument_error_message)
          end
        end
      end

      describe 'check allow_empty' do
        context 'type is not boolean' do
          let(:validator) { ArrField::InvalidAllowEmptyTypeValidator }

          it 'should RAISE ERROR' do
            expect_raise(validator)
            expect_raise_message(validator, boolean_argument_error_message)
          end
        end
      end

      describe 'check allow_nil' do
        context 'type is not boolean' do
          let(:validator) { ArrField::InvalidAllowNilTypeValidator }

          it 'should RAISE ERROR' do
            expect_raise(validator)
            expect_raise_message(validator, boolean_argument_error_message)
          end
        end
      end
    end
  end

  describe 'check default param_checker' do
    let(:validator) { ArrField::DefaultValidator }

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
        it 'value should NOT BE SET' do
          params = {}
          cmd = validator.call(params: params)

          expect_eq(cmd.result, {})
        end
      end
    end

    describe 'check default allow_nil parameter' do
      context 'field is nil' do
        it 'should BE PREVENTED' do
          params = { books: nil }
          cmd = validator.call(params: params)

          expect_fail(cmd)
          expect_eq(get_field_error(cmd), allow_nil_error_message)
        end
      end
    end

    describe 'check default allow_empty parameter' do
      context 'field is empty' do
        it 'should BE PREVENTED' do
          params = { books: [] }
          cmd = validator.call(params: params)

          expect_fail(cmd)
          expect_eq(get_field_error(cmd), allow_empty_error_message)
        end
      end
    end

    context 'field is valid' do
      it 'should PASS' do
        params = { books: ['To kill a Mockingbird'] }
        cmd = validator.call(params: params)

        expect_success(cmd)
      end
    end
  end

  describe 'check params' do
    describe 'check default value parameter' do
      context 'default value is absent' do
        let(:validator) { ArrField::DefaultValueIsAbsentValidator }

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
            params = { books: ['To kill a Mockingbird'] }
            cmd = validator.call(params: params)

            expect_eq(cmd.result, { books: ['To kill a Mockingbird'] })
          end
        end
      end

      context 'default value is present' do
        let(:validator) { ArrField::DefaultValueIsPresentValidator }

        context 'field is absent' do
          it 'value should BE SET' do
            params = {}
            cmd = validator.call(params: params)

            expect_eq(cmd.result, { books: ['Harry Potter'] })
          end
        end

        context 'field is present' do
          it 'value should NOT BE SET' do
            params = { books: ['To kill a Mockingbird'] }
            cmd = validator.call(params: params)

            expect_eq(cmd.result, { books: ['To kill a Mockingbird'] })
          end
        end
      end
    end

    describe 'check required parameter' do
      context 'required parameter is true' do
        let(:validator) { ArrField::RequiredValidator }

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
            params = { books: ['To kill a Mockingbird'] }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end
      end

      context 'required parameter is false' do
        let(:validator) { ArrField::NotRequiredValidator }

        context 'field is absent' do
          it 'should PASS' do
            params = {}
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end

        context 'field is present' do
          it 'should PASS' do
            params = { books: ['To kill a Mockingbird'] }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end
      end
    end

    describe 'check allow_nil parameter' do
      context 'allow_nil parameter is true' do
        let(:validator) { ArrField::AllowNilValidator }

        context 'field is nil' do
          it 'should PASS' do
            params = { books: nil }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end

        context 'field is not nil' do
          it 'should PASS' do
            params = { books: ['To kill a Mockingbird'] }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end
      end

      context 'allow_nil parameter is false' do
        let(:validator) { ArrField::NotAllowNilValidator }

        context 'field is nil' do
          it 'should BE PREVENTED' do
            params = { books: nil }
            cmd = validator.call(params: params)

            expect_fail(cmd)
            expect_eq(get_field_error(cmd), allow_nil_error_message)
          end
        end

        context 'field is not nil' do
          it 'should PASS' do
            params = { books: ['To kill a Mockingbird'] }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end
      end
    end

    describe 'check allow_empty parameter' do
      context 'allow_empty parameter is true' do
        let(:validator) { ArrField::AllowEmptyValidator }

        context 'field is empty' do
          it 'should PASS' do
            params = { books: [] }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end

        context 'field is not empty' do
          it 'should PASS' do
            params = { books: ['To kill a Mockingbird'] }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end
      end

      context 'allow_empty parameter is false' do
        let(:validator) { ArrField::NotAllowEmptyValidator }

        context 'field is empty' do
          it 'should BE PREVENTED' do
            params = { books: [] }
            cmd = validator.call(params: params)

            expect_fail(cmd)
            expect_eq(get_field_error(cmd), allow_empty_error_message)
          end
        end

        context 'field is not empty' do
          it 'should PASS' do
            params = { books: ['To kill a Mockingbird'] }
            cmd = validator.call(params: params)

            expect_success(cmd)
          end
        end
      end
    end
  end
end
# rubocop:enable Metricts/BlockLength
