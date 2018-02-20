require 'spec_helper'

RSpec.describe Esplanade::Request::Validation do
  subject { described_class.new(doc, raw) }

  describe '#valid!' do
    let(:doc) { double(json_schema: double) }
    let(:raw) { double(body: double(to_hash: double)) }
    before { allow(JSON::Validator). to receive(:fully_validate).and_return([]) }
    it { expect(subject.valid!).to be_nil }

    context 'invalid' do
      let(:raw) { double(method: 'method', path: 'path', body: double(to_hash: { key: 'value' })) }
      let(:message) { { method: 'method', path: 'path', body: { key: 'value' }, error: ['error'] } }
      before { allow(JSON::Validator).to receive(:fully_validate).and_return(['error']) }
      it { expect { subject.valid! }.to raise_error(Esplanade::Request::Invalid, message.to_s) }
    end
  end
end
