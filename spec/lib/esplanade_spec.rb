require 'spec_helper'

RSpec.describe Esplanade do
  context 'if not default' do
    it 'makes settings' do
      Esplanade.configure do |config|
        config.params = { prefix: 'doc/api.yaml' }
      end
    end
  end

  context 'if default' do
    it 'makes settings' do
      Esplanade.configure do |config|
        config.params = { prefix: '/api/v1' }
      end
    end
  end
end
