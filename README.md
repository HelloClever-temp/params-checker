# ParamsChecker
### Table of Content
- [Introducion](#introduction)
- [Installation](#installation)
- [Quickstart](#usage_example)
- [Usage](#usage)
  - [1. How a Params Checker command behave](#1-how-a-params-checker-command-behave)
  - [2. Schema fields](#2-schema-fields)
  - [3. Error types](#3-error-types)
  - [4. Custom validation](#4-custom-validation)
  - [5. Nested ParamsChecker](#5-nested-paramschecker)
- [More examples](#more-examples)
  - [1. Basic usage](#1-basic-usage)
  - [2. Advanced usage](#2-advanced-usage)
- [Api Details](#api-details)
  - [1. Available schema fields and their arguments](#1-available-schema-fields-and-their-arguments)
  - [2. Available schema fields's parameters](#2-available-schema-fieldss-parameters)
- [Incoming features](#incoming-features)
- [Contributing](#contributing)
- [License](#license)
## Introduction
- When your Rails application is still small, rails's model validation indeed is very convenient. Adding new validations is easy, rails always validate for you,...But once your app grows up, Rails's model validation will become messy. You have to validate differently in different use cases, your model grows big(because it contains too many validations),... That's when Params Checker comes in.
- This library is inspired by Django REST framework's validation module.
- Params Checker's only purpose is to help you validate the data. That's it.
- It's very easy and fast to use Params Checker. For more details, read [here](#api-details).
  - Example:
    ```ruby
    class CreateUserValidator < ParamsChecker::BaseParamsChecker
      def schema
        {
          age: int_field,
          email: char_field
        }
      end
    end

    cmd = CreateUserValidator.call(
      params: {}
    )

    cmd.failure?
    => true

    cmd.errors
    => {
      errors: [{
        message: 'Fields are not valid',
        error_type: 'fields_errors',
        field_errors: {
          name: 'This field is required.',
          email: 'This field is required.'
        }
      }]
    }
    ```
## Installation
Add this line to your application's Gemfile:

```ruby
gem 'params_checker'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem 'params_checker', git: 'git@gitlab.com:rexylab/params-checker.git', branch: 'master'
```
## Quickstart
- You can just use a simple params checker like this:
```ruby
class BasicUsageValidator < ParamsChecker::BaseParamsChecker
  def schema
    {
      name: char_field,
      age: int_field,
      email: char_field
    }
  end
end
```
- Or if you want more conditional validation, you can pass arguments like this. For more detail, please read [here](#2-available-schema-fields).
```ruby

class BasicUsageValidator < ParamsChecker::BaseParamsChecker
  def schema
    {
      name: char_field(min_length: 5, max_length: 255),
      age: int_field(min: 0, required: false, allow_nil: true),
      email: char_field(allow_blank: true, default: 'ted@rexy.tech')
    }
  end
end
```
- You can also add your own custom logic in checker functions. For more detail, please read [here](#4-custom-validation).

```ruby
# you can also add your own custom logic in checker functions, like this
class BasicUsageValidator < ParamsChecker::BaseParamsChecker
  def schema
    {
      name: char_field,
      age: int_field,
      email: char_field
    }
  end

  def check_name(name)
    # add error for the :name field
    add_error('This name is already exists.') if name == 'Ted Nguyen'

    # you can format your fields and return it
    name + ' RexyTech'
  end

  def check_email(email)
    # raise error, stop all others validations
    raise_error('This email is already exists.') if email == 'ted@rexy.tech'

    email
  end
end

```
## Usage
### 1. How a Params Checker command behave:
  - If your params is invalid:
    - cmd.success? will return false
    - cmd.failure? will return true
    - cmd.result will return formatted params
    - cmd.errors will return a empty hash({})
  - If your params is valid:
    - cmd.success? will return true
    - cmd.failure? will return false
    - cmd.result will return a empty hash({})
    - cmd.errors will return the errors
  - Example:
    ```ruby
    class CreateUserValidator < ParamsChecker::BaseParamsChecker
      def schema
        {
          age: int_field,
          email: char_field
        }
      end
    end

    cmd = CreateUserValidator.call(
      params: {}
    )

    cmd.failure?
    => true

    cmd.errors
    => {
      errors: [{
        message: 'Fields are not valid',
        error_type: 'fields_errors',
        field_errors: {
          name: 'This field is required.',
          email: 'This field is required.'
        }
      }]
    }
    ```
  - For more examples, read [here](#1-basic-usage).

### 2. Schema fields:
  - At the time of writing this document, Params Checker supports 16 kinds of data type checking(we call these "schema fields"). Read details about these schema fields [here](#1-available-schema-fields-and-their-arguments).
  - You can modify a schema field's arguments to tell ParamsChecker how you want to validate that specific field.
    - Example:
      ```ruby
      class Validator < ParamsChecker::BaseParamsChecker
        ## only names with a length from 5 characters to 20 characters can pass this ParamsChecker
        def schema
          {
            name: char_field(min_length: 5, max_length: 20)
          }
        end
      end
      ```
    - For more examples, read [here](#1-custom-schema-fieldss-parameters).

### 3. Error types
- Currently ParamsChecker have 2 error types
  - field_errors
    - example:
    ```ruby
      {
        errors: [{
          message: 'Fields are not valid',
          error_type: 'fields_errors',
          field_errors: {
            name: 'This field is required.'
          }
        }]
      }
    ```
  - general_error
    - example:
    ```ruby
      {
        errors: [{
          message: "Email or password invalid",
          error_type: "general_error"
        }]
      }
    ```
- A ParamsChecker validator will return field_errors when:
  - Field is invalid (validated by [schema fields](#2-schema-fields))
  - An error is raised by #add_error(Read more [here](#4-custom-validation))
- A ParamsChecker validator will return general_error when:
  - An error is raised by #raise_error(Read more [here](#4-custom-validation))
- A ParamsChecker validator can have multiple field_errors, but only have one general_error.
- If a ParamsChecker validator that have both field_errors and general_error, it will always only show the general_error.
### 4. Custom validation
  - In reality, there will be edge cases that you need to manually validate(like, validating if the user have enough permissions, validate if the user have enough balance to make transactions, ...) ParamsChecker provide checker functions to help you manually validate things ParamsChecker can not validate.
    - example:
      ```ruby
      class Validator < ParamsChecker::BaseParamsChecker
        def schema
          {
            name: char_field
          }
        end

        # you can define a custom checker function by defining
        # a method with the name convention: check_<field_name>
        # example:
        def check_name(name_param)
          # put your validation logic here.

          # the add_method will add an error to the :name field, stop all the code lines bellow it
          add_error('Name already exists.') if name_param == 'Ted Nguyen'

          # You can modify, format the param and return it here.
          name_param + ' RexyTech'
        end
      end

      # invalid params(lacking field "name")
      cmd = Validator.call(
        params: {}
      )

      cmd.failure?
      => true

      cmd.errors
      # the custom validator functions only execute once
      # the all params pass the type checking step(check
      # if name is string, check if name's length is valid,...)
      => {
        errors: [{
          message: 'Fields are not valid',
          error_type: 'fields_errors',
          field_errors: {
            name: 'This field is required.'
          }
        }]
      }

      # invalid params(Name already exists)
      cmd = Validator.call(
        params: { name: 'Ted Nguyen' }
      )

      cmd.failure?
      => true

      cmd.errors
      => {
        errors: [{
          message: 'Fields are not valid',
          error_type: 'fields_errors',
          field_errors: {
            name: 'Name already exists.'
          }
        }]
      }

      # valid params
      cmd = Validator.call(
        params: { name: 'Unique Ted Nguyen' }
      )

      cmd.failure?
      => false
      cmd.success?
      => true

      cmd.result
      => {
        name: 'Unique Ted Nguyen RexyTech'
      }

      ```
  - You can also retrieve other params to more validation by using the second parameter
    - example:
      ```ruby
      class Validator < ParamsChecker::BaseParamsChecker
        def schema
          {
            name: char_field,
            age: int_field
          }
        end

        def check_name(name_param, params)
          if name_param == 'Ted Nguyen' || params[:age] == 5
            # something like this
            add_error('Your name can not be Ted Nguyen and your age can not be 5.')
          end

          # You can pass the second argument as the field name
          # to link the error to a specify field.

          # In check_<field_name> functions, as default, the second
          # argument will be the <field_name> of the function( in
          # check_name function, it is :name)
          add_error('This name also already exists.', :age) if name_param == 'Ted Nguyen 1'

          name_param
        end
      end

      cmd = Validator.call(
        params: { name: 'Unique Ted Nguyen', age: 5 }
      )

      cmd.failure?
      => true

      cmd.errors
      => {
        errors: [{
          message: 'Fields are not valid',
          error_type: 'fields_errors',
          field_errors: {
            name: 'Your name can not be Ted Nguyen and your age can not be 5.'
          }
        }]
      }
      ```
  - You can validate multiple fields at once, removing old fields, or adding new fields by using #check
    - example:
      ```ruby
      class Validator < ParamsChecker::BaseParamsChecker
        def schema
          {
            name: char_field,
            age: int_field
          }
        end

        def check(params)
          if params[:name] == 'Ted Nguyen' || params[:age] == 5
            # In #check function, you need to specify which field should
            # ParamsChecker link the error to.
            add_error('Your name can not be Ted Nguyen and your age can not be 5.', :name)
          end

          params.except!(:age)
          params[:is_super_admin] = params[:name] == 'Admin Ted Nguyen'
          params
        end
      end

      cmd = Validator.call(
        params: { name: 'Unique Ted Nguyen', age: 5 }
      )

      cmd.failure?
      => false

      cmd.result
      => {
        name: "Unique Ted Nguyen",
        is_super_admin: false
      }
      ```
  - Besides the function #add_error to add one error message to one field, we also have #raise_error, which add the error message as the general error.
    - example:
      ```ruby
        class Validator < ParamsChecker::BaseParamsChecker
          def schema
            {
              email: char_field,
              password: char_field
            }
          end

          def check(params)
            if params[:email] != 'ted@rexy.tech' || params[:password] != 'password'
              # one ParamsChecker error can only have one general_error,
              # so if we use raise_error, it will stop all the code of
              # a ParamsChecker Validate and return general_error(while
              # add_error only stop the code of current function)
              raise_error('Email or password invalid')
            end

            params
          end
        end

        cmd = Validator.call(
          params: { email: 'ted+1@rexy.tech', password: 'password1' }
        )

        cmd.failure?
        => true

        cmd.errors
        => {
          errors: [{
            message: "Email or password invalid",
            error_type: "general_error"
          }]
        }
      ```

- For more examples, read [here](#2-using-custom-validators).
### 5. Nested ParamsChecker
- ParamsChecker also support nested ParamsChecker.
  - example:
    ```ruby
    class Mother < ParamsChecker::BaseParamsChecker
      def schema
        {
          name: char_field,
          age: int_field
        }
      end
    end

    class Kid < ParamsChecker::BaseParamsChecker
      def schema
        {
          name: char_field,
          age: int_field,
          mother: Mother.init
        }
      end
    end

    cmd = Kid.call(
      params: {
        name: 'Ted',
        age: 15,
        mother: {
          name: "Ted's mother",
        }
      }
    )

    cmd.failure?
    => true
    cmd.errors
    => {
      errors: [{
        message: 'Fields are not valid',
        error_type: 'fields_errors',
        field_errors: {
          mother: {
            age: "This field is required."
          }
        }
      }]
    }

    cmd = Kid.call(
      params: {
        name: 'Ted',
        age: 15,
        mother: {
          name: "Ted's mother",
          age: 35
        }
      }
    )

    cmd.failure?
    => false
    ```

- You can also pass the argument "many", to treat the it as an array of multiple ParamsCheckers:
  - example:
    ```ruby
    class Book < ParamsChecker::BaseParamsChecker
      def schema
        {
          name: char_field,
          released_at: date_field,
        }
      end
    end

    class Author < ParamsChecker::BaseParamsChecker
      def schema
        {
          name: char_field,
          age: int_field,
          books: Book.init(many: true)
        }
      end
    end

    cmd = Author.call(
      params: {
        name: 'Ted',
        age: 15,
        books: [
          {
            name: 'Harry Potter 1',
            released_at: '1997-06-26'
          },
          {
            name: 'Harry Potter 2',
          },
          {
            name: 'Harry Potter 3',
            released_at: '1999-07-08'
          },
        ]
      }
    )

    cmd.failure?
    => true
    cmd.errors
    => {
      errors: [{
        message: 'Fields are not valid',
        error_type: 'fields_errors',
        field_errors: {
          books: [
            nil,
            {
              released_at: "This field is required."
            },
            nil
          ]
        }
      }]
    }
    ```

## More examples
### 1. Basic usage
```ruby
class BasicUsageValidator < ParamsChecker::BaseParamsChecker
  def schema
    {
      name: char_field,
      age: int_field,
      email: char_field
    }
  end
end

# validate number 1
params = {}
cmd = BasicUsageValidator.call(
  params: params
)

cmd.success?
=> false
cmd.failure?
=> true

cmd.result
=> {}
cmd.errors
=> {
  errors: [{
    message: 'Fields are not valid',
    error_type: 'fields_errors',
    field_errors: {
      name: 'This field is required.',
      age: 'This field is required.',
      email: 'This field is required.'
    }
  }]
}

# validate number 2
params = {
  name: true,
  email: 'ted@rexy.tech'
}
cmd = BasicUsageValidator.call(
  params: params
)

cmd.success?
=> false
cmd.failure?
=> true

cmd.result
=> {}
cmd.errors
=> {
  errors: [{
    message: 'Fields are not valid',
    error_type: 'fields_errors',
    field_errors: {
      name: "This field's type must be string.",
      age: 'This field is required.'
    }
  }]
}

# validate number 3
params = {
  name: 'ted nguyen',
  age: 2_000_000_001,
  email: 'a' * 256
}
cmd = BasicUsageValidator.call(
  params: params
)

cmd.success?
=> false
cmd.failure?
=> true

cmd.result
=> {}
cmd.errors
=> {
  errors: [{
    message: 'Fields are not valid',
    error_type: 'fields_errors',
    field_errors: {
      age: "This integer field's value must be in range from -2000000000 to 2000000000.",
      email: "This string field's length must be in range from 0 to 255."
    }
  }]
}


# validate number 4
params = {
  name: 'ted nguyen',
  age: 23,
  email: 'ted@rexy.tech'
}
cmd = BasicUsageValidator.call(
  params: params
)

cmd.success?
=> true
cmd.failure?
=> false

cmd.result
=> {
  name: 'ted nguyen',
  age: 23,
  email: 'ted@rexy.tech'
}
cmd.errors
=> {}

```
### 2. Advance usage
##### 1. Custom schema fields's parameters

```ruby
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

# validate number 5
params = {
  name: 'Ted',
  age: 135,
  email: '',
  phone: ''
}
cmd = AdvancedUsageValidator.call(
  params: params
)

cmd.success?
=> false
cmd.failure?
=> true

cmd.result
=> {}
cmd.errors
=> {
  errors: [{
    message: 'Fields are not valid',
    error_type: 'fields_errors',
    field_errors: {
      name: "This string field's length must be in range from 4 to 30.",
      age: "This integer field's value must be in range from -2000000000 to 130.",
      email: 'This field cannot be blank.'
    }
  }]
}

# validate number 6
params = {
  name: 'Ted Nguyen',
  age: 23,
  email: 'ted@rexy.tech',
  phone: ''
}
cmd = AdvancedUsageValidator.call(
  params: params
)

cmd.success?
=> true
cmd.failure?
=> false

cmd.result
=> {
  name: 'Ted Nguyen',
  age: 23,
  email: 'ted@rexy.tech',
  phone: ''
}
cmd.errors
=> {}
```
##### 2. Using custom validators

```ruby
class AnotherAdvancedValidator < ParamsChecker::BaseParamsChecker
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

  def check(params)
    raise_error("You don't have permission to create a user.") unless context[:is_super_admin]

    params[:is_adult] = params[:age] >= 18
    params
  end
end

# validate number 7
params = {
  name: 'Ted Nguyen',
  age: 17,
  email: 'ted@rexy.tech'
}
cmd = AdvancedUsageValidator.call(
  params: params
)

cmd.success?
=> false
cmd.failure?
=> true

cmd.result
=> {}
cmd.errors
=> {
  errors: [
    {
      message: "This email is already exists.",
      error_type: "general_error"
    }
  ]
}

# validate number 8
params = {
  name: 'Ted Nguyen',
  age: 17,
  email: 'ted+1@rexy.tech'
}
cmd = AdvancedUsageValidator.call(
  params: params
)

cmd.success?
=> false
cmd.failure?
=> true

cmd.result
=> {}
cmd.errors
=> {
  errors: [
    {
      message: "You don't have permission to create a user.",
      error_type: "general_error"
    }
  ]
}

# validate number 9
params = {
  name: 'Ted Nguyen',
  age: 17,
  email: 'ted+1@rexy.tech'
}
cmd = AdvancedUsageValidator.call(
  params: params
)

cmd.success?
=> false
cmd.failure?
=> true

cmd.result
=> {}
cmd.errors
=> {
  errors: [{
    message: 'Fields are not valid',
    error_type: 'fields_errors',
    field_errors: {
      name: 'This name is already exists.',
      age: 'You must be older than 18 years old.'
    }
  }]
}

# validate number 10
params = {
  name: 'Teddy Nguyen',
  age: 19,
  email: 'ted+1@rexy.tech'
}
cmd = AdvancedUsageValidator.call(
  params: params
)

cmd.success?
=> false
cmd.failure?
=> true

cmd.result
=> {
  name: 'Teddy Nguyen',
  age: 19,
  email: 'ted+1@rexy.tech'
}
cmd.errors
=> {}
```

## Api Details
### 1. Available schema fields and their arguments:
  - text_field
    - [default](#default)
    - [allow_blank](#allow_blank)
    - [min_length](#min_length)
    - [max_length](#max_length)
    - [allow_nil](#allow_nil)
  - char_field
    - [required](#required)
    - [default](#default)
    - [allow_blank](#allow_blank)
    - [min_length](#min_length)
    - [max_length](#max_length)
    - [allow_nil](#allow_nil)
  - bignum_field
    - [required](#required)
    - [default](#default)
    - [min](#min)
    - [max](#max)
    - [allow_nil](#allow_nil)
  - num_field
    - [required](#required)
    - [default](#default)
    - [min](#min)
    - [max](#max)
    - [allow_nil](#allow_nil)
  - bigint_field
    - [required](#required)
    - [default](#default)
    - [min](#min)
    - [max](#max)
    - [allow_nil](#allow_nil)
  - int_field
    - [required](#required)
    - [default](#default)
    - [min](#min)
    - [max](#max)
    - [allow_nil](#allow_nil)
  - positive_bignum_field
    - [required](#required)
    - [default](#default)
    - [min](#min)
    - [max](#max)
    - [allow_nil](#allow_nil)
  - positive_num_field
    - [required](#required)
    - [default](#default)
    - [min](#min)
    - [max](#max)
    - [allow_nil](#allow_nil)
  - positive_bigint_field
    - [required](#required)
    - [default](#default)
    - [min](#min)
    - [max](#max)
    - [allow_nil](#allow_nil)
  - positive_int_field
    - [required](#required)
    - [default](#default)
    - [min](#min)
    - [max](#max)
    - [allow_nil](#allow_nil)
  - arr_field
    - [required](#required)
    - [default](#default)
    - [allow_empty](#allow_empty)
    - [allow_nil](#allow_nil)
  - hash_field
    - [required](#required)
    - [default](#default)
    - [allow_nil](#allow_nil)
  - date_field
    - [required](#required)
    - [default](#default)
    - [allow_nil](#allow_nil)
  - time_field
    - [required](#required)
    - [default](#default)
    - [allow_nil](#allow_nil)
  - datetime_field
    - [required](#required)
    - [default](#default)
    - [allow_nil](#allow_nil)
  - boolean_field
    - [required](#required)
    - [default](#default)
    - [allow_nil](#allow_nil)

### 2. Available schema fields's parameters:
##### required

  - description: to indicate that if you need to validate field's presence or not.
  - default value: true
  - type: boolean
  - example:
    ```ruby
    class Validator < ParamsChecker::BaseParamsChecker
      def schema
      {
        name: char_field(required: false)
      }
      end
    end
    ```
##### default:
  - description: if field is absent, this value will be set to field.
  - default value: nil
  - type: base on field type
  - example:
    ```ruby
    class Validator < ParamsChecker::BaseParamsChecker
      def schema
      {
        name: char_field(default: 'Ted Nguyen')
      }
      end
    end
    ```
##### allow_nil
  - description: to indicate that if you need to validate if field is nil or not.
  - default value: false
  - type: boolean
  - example:
    ```ruby
    class Validator < ParamsChecker::BaseParamsChecker
      def schema
      {
        name: char_field(allow_nil: true)
      }
      end
    end
    ```
##### allow_blank
  - description: to indicate that if you need to validate if field is blank or not.
  - default value: false
  - type: boolean
  - example:
    ```ruby
    class Validator < ParamsChecker::BaseParamsChecker
      def schema
      {
        name: char_field(allow_blank: true)
      }
      end
    end
    ```
##### allow_empty
  - description: to indicate that if you need to validate field's emptiness or not.
  - default value: false
  - type: boolean
    - example:
    ```ruby
    class Validator < ParamsChecker::BaseParamsChecker
      def schema
      {
        books: arr_field(allow_empty: true)
      }
      end
    end
    ```
##### min_length
  - description: to limit minimum string length that the params can pass.
  - applicable schema fields:
    - char_field:
      - default value: 0
      - acceptable argument value: from 0 to 255
      - type: integer
    - text_field:
      - default value: 0
      - acceptable argument value: from 0 to 30_000
      - type: integer
  - example:
    ```ruby
    class Validator < ParamsChecker::BaseParamsChecker
      def schema
      {
        name: char_field(min_length: 5)
      }
      end
    end
    ```
##### max_length
- description: to limit minimum string length that the params can pass.
- applicable schema fields:
  - char_field:
    - default value: 0
    - acceptable argument value: from 0 to 255
    - type: integer
  - text_field:
    - default value: 0
    - acceptable argument value: from 0 to 30_000
    - type: integer
- example:
    ```ruby
    class Validator < ParamsChecker::BaseParamsChecker
      def schema
      {
        name: char_field(max_length: 10)
      }
      end
    end
    ```
##### min
  - description: to limit minimum value that the params can pass.
  - applicable schema fields:
    - int_field:
      - default value: 0
      - acceptable argument value: from -2_000_000_000 to 2_000_000_000
      - type: integer
    - bigint_field:
      - default value: 0
      - acceptable argument value: from -2_000_000_000_000 to 2_000_000_000_000
      - type: integer
    - positive_int_field:
      - default value: 0
      - acceptable argument value: from 0 to 2_000_000_000
      - type: integer
    - positive_bigint_field:
      - default value: 0
      - acceptable argument value: from 0 to 2_000_000_000_000
      - type: integer
    - num_field:
      - default value: 0
      - acceptable argument value: from -2_000_000_000 to 2_000_000_000
      - type: integer, decimal
    - bignum_field:
      - default value: 0
      - acceptable argument value: from -2_000_000_000_000 to 2_000_000_000_000
      - type: integer, decimal
    - positive_num_field:
      - default value: 0
      - acceptable argument value: from 0 to 2_000_000_000
      - type: integer, decimal
    - positive_bignum_field:
      - default value: 0
      - acceptable argument value: from 0 to 2_000_000_000_000
      - type: integer, decimal
  - example:
    ```ruby
    class Validator < ParamsChecker::BaseParamsChecker
      def schema
      {
        age: int_field(min: 18)
      }
      end
    end
    ```
##### max
  - description: to limit maximum value that the params can pass.
  - applicable schema fields:
    - int_field:
      - default value: 0
      - acceptable argument value: from -2_000_000_000 to 2_000_000_000
      - type: integer
    - bigint_field:
      - default value: 0
      - acceptable argument value: from -2_000_000_000_000 to 2_000_000_000_000
      - type: integer
    - positive_int_field:
      - default value: 0
      - acceptable argument value: from 0 to 2_000_000_000
      - type: integer
    - positive_bigint_field:
      - default value: 0
      - acceptable argument value: from 0 to 2_000_000_000_000
      - type: integer
    - num_field:
      - default value: 0
      - acceptable argument value: from -2_000_000_000 to 2_000_000_000
      - type: integer, decimal
    - bignum_field:
      - default value: 0
      - acceptable argument value: from -2_000_000_000_000 to 2_000_000_000_000
      - type: integer, decimal
    - positive_num_field:
      - default value: 0
      - acceptable argument value: from 0 to 2_000_000_000
      - type: integer, decimal
    - positive_bignum_field:
      - default value: 0
      - acceptable argument value: from 0 to 2_000_000_000_000
      - type: integer, decimal
  - example:
    ```ruby
    class Validator < ParamsChecker::BaseParamsChecker
      def schema
      {
        age: int_field(max: 130)
      }
      end
    end
    ```

## Incoming features(incoming)
## Contributing
Contribution directions go here.
## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
