require 'spec_helper'

RSpec.describe Esplanade::Request::Raw::Body do
  subject { described_class.new(raw_request, env) }
  let(:raw_request) { double }
  let(:env) { double }

  describe '#to_string' do
    let(:body) { double }
    let(:env) { { 'rack.input' => double(read: body, rewind: nil) } }
    it { expect(subject.to_string).to eq(body) }
  end

  describe '#to_hash' do
    before { allow(subject).to receive(:to_string).and_return('{"state": 1}') }
    it { expect(subject.to_hash).to eq('state' => 1) }

    context 'body nil' do
      before { allow(subject).to receive(:to_string).and_return(nil) }
      it { expect(subject.to_hash).to eq({}) }
    end

    context 'can not parse body of request' do
      let(:raw_request) { double(method: 'method', path: 'path') }
      let(:message) { '{:method=>"method", :path=>"path", :body=>"{\"state\": 1"}' }
      before { allow(subject).to receive(:to_string).and_return('{"state": 1') }
      it { expect { subject.to_hash }.to raise_error(Esplanade::Request::BodyIsNotJson, message) }
    end
  end
end
