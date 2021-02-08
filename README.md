# ParamsChecker
### Table of Content
- [Introdutions](#introdutions)
- [Installation](#installation)
- [Usage](#usage)
- [Advanced Usage](#advanced_usage)
- [Contributing](#contributing)
- [License](#license)
## Introdutions
- This library is inspired by Django REST framework's validation module.
- 
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
$ gem 'params_checker', git: 'git@gitlab.com:rexylab/params-checker.git', branch: 'development'
```
## Usage
```ruby
class CreateUserValidator < ParamsChecker::BaseParamsChecker
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

  def check_age(age, opts)
    add_error('You must be older than 18 years old.') if age < 18 && opts[:name] == 'Ted Nguyen'

    name
  end

  def check_email(email)
    raise_error('This email is already exists.') if email == 'ted@rexy.tech'

    age
  end

  def check(opts)
    raise_error("You don't have permission to create a user.") unless context[:is_super_admin]

    opts
  end
end

# validate number 1
params = {
  name: 'Ted',
  age: 11,
  email: 'ted@rexy.tech'
}

context = {
  is_super_admin: true
}

cmd = CreateUserValidator.call(
  params: params,
  context: context
)


```
## Advanced Usage
## Details
- Params Checker has total 16 types of schema fields: 

## Incoming features
## Incoming features

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
