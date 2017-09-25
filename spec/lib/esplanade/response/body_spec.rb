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
    let(:hash) { double }

    before { allow(subject).to receive(:hash_and_parsed).and_return([hash]) }

    it { expect(subject.to_h).to eq(hash) }
  end

  describe '#parsed?' do
    let(:parsed) { double }

    before { allow(subject).to receive(:hash_and_parsed).and_return([double, parsed]) }

    it { expect(subject.parsed?).to eq(parsed) }
  end

  describe '#hash_and_parsed' do
    let(:to_s) { '{"state": 1}' }

    before { allow(subject).to receive(:to_s).and_return(to_s) }

    it { expect(subject.hash_and_parsed).to eq([{ 'state' => 1 }, true]) }

    context 'invalid' do
      let(:to_s) { '{"state": 1' }
      it { expect(subject.hash_and_parsed).to eq([{}, false]) }
    end
  end
end
