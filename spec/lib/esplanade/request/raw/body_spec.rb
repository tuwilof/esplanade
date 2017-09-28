require 'spec_helper'

RSpec.describe Esplanade::Request::Raw::Body do
  subject { described_class.new(env) }

  let(:env) { double }

  describe '#to_s' do
    let(:string) { double }

    before { allow(subject).to receive(:string_and_received).and_return([string]) }

    it { expect(subject.to_s).to eq(string) }
  end

  describe '#to_h' do
    let(:hash) { double }

    before { allow(subject).to receive(:hash_and_json).and_return([hash]) }

    it { expect(subject.to_h).to eq(hash) }
  end

  describe '#received?' do
    let(:received) { double }

    before { allow(subject).to receive(:string_and_received).and_return([double, received]) }

    it { expect(subject.received?).to eq(received) }
  end

  describe '#json?' do
    let(:json) { double }

    before { allow(subject).to receive(:hash_and_json).and_return([double, json]) }

    it { expect(subject.json?).to eq(json) }
  end

  describe '#string_and_received' do
    let(:body) { double }
    let(:env) { { 'rack.input' => double(read: body) } }

    it { expect(subject.string_and_received).to eq([body, true]) }

    context 'invalid' do
      let(:env) { nil }
      it { expect(subject.string_and_received).to eq(['', false]) }
    end
  end

  describe '#hash_and_json' do
    let(:to_s) { '{"state": 1}' }

    before { allow(subject).to receive(:to_s).and_return(to_s) }

    it { expect(subject.hash_and_json).to eq([{ 'state' => 1 }, true]) }

    context 'invalid' do
      let(:to_s) { '{"state": 1' }
      it { expect(subject.hash_and_json).to eq([{}, false]) }
    end
  end
end
