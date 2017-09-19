require 'spec_helper'

RSpec.describe Esplanade::Request::Body do
  describe '.craft' do
    subject { described_class.craft('rack.input' => double(read: body)) }

    context 'empty string' do
      let(:body) { '' }
      it { expect(subject).to eq({}) }
    end

    context 'valid json' do
      let(:body) { '{"state": 1}' }
      it { expect(subject).to eq('state' => 1) }
    end
  end
end
