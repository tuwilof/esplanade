require 'spec_helper'

RSpec.describe Esplanade::Response::Raw::Body do
  subject { described_class.new(request, raw_response, raw_body) }
  let(:request) { double }
  let(:raw_response) { double }
  let(:raw_body) { double }

  describe '#to_string' do
    let(:body) { double }
    let(:raw_body) { [body] }
    it { expect(subject.to_string).to eq(body) }

    context 'can not get body of response' do
      let(:raw_body) { nil }
      it { expect { subject.to_string }.to raise_error(Esplanade::RawResponseError) }
    end
  end

  describe '#to_hash' do
    before { allow(subject).to receive(:to_string).and_return('{"state": 1}') }
    it { expect(subject.to_hash).to eq('state' => 1) }

    context 'can not parse body of response' do
      let(:request) { double(raw: double(method: 'method', path: 'path')) }
      let(:raw_response) { double(status: 'status', body: double(to_string: 'body')) }
      let(:message) { '{:request=>{:method=>"method", :path=>"path"}, :status=>"status", :body=>"body"}' }
      before { allow(subject).to receive(:to_string).and_return('{"state": 1') }
      it { expect { subject.to_hash }.to raise_error(Esplanade::ResponseBodyIsNotJson, message) }
    end
  end

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
    let(:raw_body) { ['{"state": 1}'] }
    it { expect(subject.string_and_received).to eq(['{"state": 1}', true]) }

    context 'invalid' do
      let(:raw_body) { nil }
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
