require 'spec_helper'

RSpec.describe Esplanade::Response::Body do
  subject { described_class.new(body) }

  let(:body) { double }

  describe '#to_s' do
    let(:body) { ['{"state": 1}'] }

    it { expect(subject.to_s).to eq('{"state": 1}') }

    context 'invalid' do
      let(:body) { nil }
      it { expect(subject.to_s).to eq('') }
    end
  end

  describe '#to_h' do
    let(:to_s) { '{"state": 1}' }

    before { allow(subject).to receive(:to_s).and_return(to_s) }

    it { expect(subject.to_h).to eq('state' => 1) }

    context 'invalid' do
      let(:to_s) { '{"state": 1' }
      it { expect(subject.to_h).to eq({}) }
    end
  end
end
