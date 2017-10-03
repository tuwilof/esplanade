require 'spec_helper'

RSpec.describe Esplanade::Request::Validation do
  subject { described_class.new(raw, doc) }

  describe '#valid!' do
    let(:raw) { double(body: double(to_hash: double)) }
    let(:doc) { double(json_schema: double) }
    before { allow(JSON::Validator). to receive(:fully_validate).and_return([]) }
    it { expect(subject.valid!).to be_nil }

    context 'invalid' do
      let(:raw) { double(method: 'method', path: 'path', body: double(to_string: 'body', to_hash: double)) }
      let(:message) { "{:method=>\"method\", :path=>\"path\", :body=>\"body\", :error=>\"error\"}" }
      before { allow(JSON::Validator).to receive(:fully_validate).and_return('error') }
      it { expect { subject.valid! }.to raise_error(Esplanade::RequestInvalid, message) }
    end
  end
end
