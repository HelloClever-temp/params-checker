# type: type
# required: required
# default: default
# many: many
# class: self

module NestedHashField
  class Person2Validator < ParamsChecker::BaseParamsChecker
    def init
      {
        is_male: boolean_field,
        birth_day: date_field
      }
    end
  end

  class Person4Validator < ParamsChecker::BaseParamsChecker
    def init
      {
        example_boolean_field: boolean_field,
        example_date_field: date_field,
        example_text_field: text_field,
        example_char_field: char_field,
        example_num_field: num_field,
        example_bignum_field: bignum_field,
        example_bigint_field: bigint_field,
        example_int_field: int_field,
        example_positive_bignum_field: positive_bignum_field,
        example_positive_num_field: positive_num_field,
        example_positive_bigint_field: positive_bigint_field,
        example_positive_int_field: positive_int_field,
        example_arr_field: arr_field,
        example_hash_field: Person5Validator.init,
        example_time_field: time_field,
        example_datetime_field: datetime_field
      }
    end
  end

  class Person5Validator < ParamsChecker::BaseParamsChecker
    def init
      {
        money: bigint_field,
        birth_time: time_field
      }
    end
  end

  class Person1Validator < ParamsChecker::BaseParamsChecker
    def init
      {
        name: char_field,
        age: int_field,
        person2: Person2Validator.init
      }
    end
  end

  class Person3Validator < ParamsChecker::BaseParamsChecker
    def init
      {
        person2: Person2Validator.init
      }
    end
  end

  class PersonValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        name: char_field,
        age: int_field
      }
    end
  end

  class DefaultValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        person: PersonValidator.init
      }
    end
  end

  class ManyNestedHashValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        person: PersonValidator.init(many: true)
      }
    end
  end

  class BasicMultipleNestedHashValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        person1: Person1Validator.init
      }
    end
  end

  class SyntheticValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        person4: Person4Validator.init
      }
    end
  end

  class DefaultValueIsPresentValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        person: PersonValidator.init(default: { name: 'Vu', age: 14 })
      }
    end
  end

  class DefaultValueIsAbsentValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        person: PersonValidator.init
      }
    end
  end

  class NotRequiredValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        person: PersonValidator.init(required: false)
      }
    end
  end

  class RequiredValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        person: PersonValidator.init(required: true)
      }
    end
  end

  class MinValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        person: PersonValidator.init(min: 10)
      }
    end
  end

  class MaxValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        person: PersonValidator.init(max: 9)
      }
    end
  end

  class NotAllowNilValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        person: PersonValidator.init(allow_nil: false)
      }
    end
  end

  class AllowNilValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        person: PersonValidator.init(allow_nil: true)
      }
    end
  end

  class InvalidMinTypeValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        person: PersonValidator.init(min: 'invalid_min')
      }
    end
  end

  class InvalidMaxTypeValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        person: PersonValidator.init(max: 'invalid_max')
      }
    end
  end

  class InvalidRequiredTypeValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        person: PersonValidator.init(required: 'invalid_required')
      }
    end
  end

  class InvalidAllowNilTypeValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        person: PersonValidator.init(allow_nil: 'invalid_allow_nil')
      }
    end
  end

  class InvalidManyTypeValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        person: PersonValidator.init(many: 'invalid_allow_nil')
      }
    end
  end

  class InvalidMinValueValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        person: PersonValidator.init(min: -2_000_000_001)
      }
    end
  end

  class InvalidMaxValueValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        person: PersonValidator.init(max: 2_000_000_001)
      }
    end
  end

  class AddErrorValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        name: char_field,
        age: int_field,
        email: char_field
      }
    end

    def check_name(name)
      add_error('This name is already exists.', :name) if name == 'Ted Nguyen'

      name
    end

    def check_age(age, opts)
      add_error('You must be older than 18 years old.') if age < 18 && opts[:name] == 'Ted Nguyen'

      name
    end

    def check(opts)
      add_error('This email is already exists.', :email) if opts[:email] == 'ted@rexy.tech'

      opts
    end
  end

  class RaiseErrorValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        name: char_field,
        age: int_field,
        email: char_field
      }
    end

    def check_name(name)
      raise_error('This name is already exists.') if name == 'Ted Nguyen'

      name
    end

    def check_age(age, opts)
      raise_error('You must be older than 18 years old.') if age < 18 && opts[:name] == 'Ted Nguyen'

      name
    end

    def check(opts)
      raise_error('This email is already exists.') if opts[:email] == 'ted@rexy.tech'

      opts
    end
  end

  class RaiseErrorAndAddErrorValidator < ParamsChecker::BaseParamsChecker
    def init
      {
        name: char_field,
        age: int_field,
        email: char_field
      }
    end

    def check_name(name)
      add_error('This name is already exists.') if name == 'Ted Nguyen'

      name
    end

    def check_age(age, opts)
      add_error('You must be older than 18 years old.') if age < 18 && opts[:name] == 'Ted Nguyen'

      name
    end

    def check(opts)
      raise_error('This email is already exists.') if opts[:email] == 'ted@rexy.tech'

      opts
    end
  end

end