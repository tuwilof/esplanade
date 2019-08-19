require 'spec_helper'

RSpec.describe Esplanade::Request::Validation do
  subject { described_class.new(doc, raw) }

  describe '#valid!' do
    let(:doc) { double(json_schema: double, content_type: 'application/json') }
    let(:raw) { double(body: double(to_hash: double), content_type: 'application/json') }
    before { allow(JSON::Validator).to receive(:fully_validate).and_return([]) }
    it { expect(subject.valid!).to be_nil }

    context 'invalid' do
      let(:raw) { double(method: 'method', path: 'path', content_type: 'application/json', body: double(to_hash: { key: 'value' }, to_string: '')) }
      let(:message) { { method: 'method', path: 'path', content_type: 'application/json', body: { key: 'value' }, error: ['error'] } }
      before { allow(JSON::Validator).to receive(:fully_validate).and_return(['error']) }
      it { expect { subject.valid! }.to raise_error(Esplanade::Request::Invalid, message.to_s) }
    end

    context 'content-type is not json' do
      let(:doc) { double(method: 'method', path: 'path', content_type: 'multipart/form-data;boundary=BOUNDARY') }
      let(:raw) { double(method: 'method', path: 'path', content_type: 'multipart/form-data;boundary=BOUNDARY', body: double(to_hash: { key: 'value' }, to_string: '')) }
      let(:message) { { method: 'method', path: 'path', content_type: 'multipart/form-data;boundary=BOUNDARY' } }
      it { expect { subject.valid! }.to raise_error(Esplanade::Request::ContentTypeIsNotJson, message.to_s) }
    end
  end
end
