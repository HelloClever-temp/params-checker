RSpec.shared_context 'required_error_message' do
  let(:required_error_message) { 'This field is required.' }
end

RSpec.shared_context 'allow_blank_error_message' do
  let(:allow_blank_error_message) { 'This field cannot be blank.' }
end

RSpec.shared_context 'integer_argument_error_message' do
  let(:integer_argument_error_message) { "This field's type must be integer." }
end

RSpec.shared_context 'numberic_argument_error_message' do
  let(:numberic_argument_error_message) { "This field's type must be numberic." }
end

RSpec.shared_context 'boolean_argument_error_message' do
  let(:boolean_argument_error_message) { "This field's type must be boolean." }
end