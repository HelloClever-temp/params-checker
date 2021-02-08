require 'rails_helper'
require 'validators/readme_examples'
require 'shared_contexts/base'
require 'helper/base'

# rubocop:disable Metricts/BlockLength
RSpec.describe 'readme_examples', type: :helper do
  include_context 'error_messages'

  describe 'showcase basic usage' do
    let(:validator) { ReadmeExamples::BasicUsageValidator }

    context 'params are invalid' do
      describe 'validate number 1' do
        it 'should BE PREVENTED' do
          params = {}
          cmd = validator.call(params: params)
          binding.pry
          expect_success(cmd)
        end
      end
    end
  end
end
# rubocop:enable Metricts/BlockLength
