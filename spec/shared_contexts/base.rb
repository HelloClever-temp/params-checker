RSpec.shared_context 'error_messages' do
  let(:required_error_message) { 'This field is required.' }
  let(:allow_blank_error_message) { 'This field cannot be blank.' }
  let(:integer_argument_error_message) { "This field's type must be integer." }
  let(:numeric_argument_error_message) { "This field's type must be numeric." }
  let(:boolean_argument_error_message) { "This field's type must be boolean." }
  let(:allow_nil_error_message) { "This field's type must be integer." }
  let(:int_length_error_message) { 'Invalid integer value.' }
  let(:num_length_error_message) { 'Invalid numeric value.' }
end
