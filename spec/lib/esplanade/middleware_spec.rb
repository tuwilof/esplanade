require 'spec_helper'

RSpec.describe Esplanade::Middleware do
  describe '#call' do
    subject { described_class.new(app, drafter_yaml_path: 'doc.yml') }

    let(:app) { double(call: [status, headers, body]) }
    let(:status) { double }
    let(:headers) { double }
    let(:body) { double }
    let(:env) { double }

    before do
      allow(Tomograph::Tomogram).to receive(:new).with(drafter_yaml_path: 'doc.yml')
    end

    it 'returns response' do
      expect(subject.call(env)).to eq([status, headers, body])
    end
  end
end
