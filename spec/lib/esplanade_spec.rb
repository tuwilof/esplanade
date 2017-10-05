require 'spec_helper'

RSpec.describe Esplanade do
  context 'if not default' do
    it 'makes settings' do
      Esplanade.configure do |config|
        config.drafter_yaml_path = 'doc/api.yaml'
      end
    end
  end

  context 'if default' do
    it 'makes settings' do
      Esplanade.configure do |config|
        config.prefix = '/api/v1'
      end
    end
  end
end
