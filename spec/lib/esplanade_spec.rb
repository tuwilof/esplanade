require 'spec_helper'

RSpec.describe Esplanade do
  context 'if not default' do
    it 'makes settings' do
      Esplanade.configure do |config|
        config.tomogram = 'doc/api.yaml'
      end
    end
  end

  context 'if default' do
    before do
      stub_const('Tomograph::Tomogram', nil)
      allow(Tomograph::Tomogram).to receive(:json).and_return({})
    end

    it 'makes settings' do
      Esplanade.configure do |config|
        config.skip_not_documented = false
      end
    end
  end
end
