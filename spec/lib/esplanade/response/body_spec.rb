require 'spec_helper'

RSpec.describe Esplanade::Response::Body do
  describe '.craft' do
    subject { described_class.craft(body) }

    context 'empty body' do
      let(:body) { [] }
      it { expect(subject).to eq({}) }
    end

    context 'valid json' do
      let(:body) { ['{"state": 1}'] }
      it { expect(subject).to eq('state' => 1) }
    end

    context 'invalid json' do
      let(:body) { ['{"state": 1'] }
      it { expect(subject).to eq('{"state": 1') }
    end

    context 'body nil' do
      let(:body) { nil }
      it { expect(subject).to be_nil }
    end
  end
end
