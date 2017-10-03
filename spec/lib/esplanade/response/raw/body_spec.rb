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
end
