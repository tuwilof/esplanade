require 'spec_helper'

RSpec.describe Esplanade::Request::Body do
  describe '.craft' do
    subject { described_class.craft(env) }

    let(:env) { { 'rack.input' => rack_input } }
    let(:rack_input) { double(read: body) }

    context 'empty string' do
      let(:body) { '' }
      it { expect(subject).to eq({}) }
    end

    context 'valid json' do
      let(:body) { '{"state": 1}' }
      it { expect(subject).to eq('state' => 1) }
    end

    context 'env nil' do
      let(:env) { nil }
      it { expect(subject).to be_nil }
    end

    context 'rack.input nil' do
      let(:rack_input) { nil }
      it { expect(subject).to be_nil }
    end
  end
end
