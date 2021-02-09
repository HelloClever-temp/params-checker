module ReadmeExamples
  class BasicUsageValidator < ParamsChecker::BaseParamsChecker
    def schema
      {
        name: char_field,
        age: int_field,
        email: char_field
      }
    end
  end

  class AdvancedUsageValidator < ParamsChecker::BaseParamsChecker
    def schema
      {
        name: char_field(min_length: 4, max_length: 30),
        age: int_field(max: 130),
        email: char_field,
        is_male: boolean_field(required: false, default: true),
        phone: char_field(allow_blank: true)
      }
    end
  end

  class CustomValidator < ParamsChecker::BaseParamsChecker
    def schema
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

    def check_age(age)
      add_error('You must be older than 18 years old.') if age < 18

      age
    end

    def check_email(email)
      raise_error('This email is already exists.') if email == 'ted@rexy.tech'

      email
    end

    def check(opts)
      raise_error("You don't have permission to create a user.") unless context[:is_super_admin]

      opts[:is_adult] = opts[:age] >= 18
      opts
    end
  end
end