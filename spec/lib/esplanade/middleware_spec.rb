require 'spec_helper'

RSpec.describe Esplanade::Middleware do
  describe '#call' do
    subject { described_class.new(app) }

    let(:app) { double(call: [status, headers, body]) }
    let(:status) { double }
    let(:headers) { double }
    let(:body) { double }
    let(:env) { double }

    before do
      allow(Tomograph::Tomogram).to receive(:new)
    end

    it 'returns response' do
      expect(subject.call(env)).to eq([status, headers, body])
    end
  end
end
