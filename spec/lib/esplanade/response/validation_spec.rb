require 'spec_helper'

RSpec.describe Esplanade::Response::Validation do
  subject { described_class.new(request, doc, raw) }

  let(:request) { double }
  let(:raw) { double }
  let(:doc) { double }

  describe '#valid!' do
    context 'one json-schema' do
      let(:raw) { double(body: double(to_hash: double)) }
      let(:doc) { double(json_schemas: [double]) }
      before { allow(JSON::Validator).to receive(:fully_validate).and_return([]) }
      it { expect(subject.valid!).to be_nil }

      context 'invalid' do
        let(:request) { double(raw: double(method: 'method', path: 'path')) }
        let(:raw) { double(status: 'status', body: double(to_hash: double)) }
        let(:message) do
          '{:request=>{:method=>"method", :path=>"path"}, '\
          ':status=>"status", :body=>#<Double (anonymous)>, :error=>"[error]"}'
        end
        before { allow(JSON::Validator).to receive(:fully_validate).and_return('[error]') }
        it { expect { subject.valid! }.to raise_error(Esplanade::ResponseInvalid, message) }
      end
    end

    context 'more than one json-schema' do
      let(:raw) { double(body: double(to_hash: double)) }
      let(:doc) { double(json_schemas: [double, double]) }
      before { allow(JSON::Validator).to receive(:fully_validate).and_return([]) }
      it { expect(subject.valid!).to be_nil }

      context 'invalid' do
        let(:request) { double(raw: double(method: 'method', path: 'path')) }
        let(:raw) { double(status: 'status', body: double(to_hash: double)) }
        let(:message) do
          '{:request=>{:method=>"method", :path=>"path"}, '\
          ':status=>"status", :body=>#<Double (anonymous)>, :error=>["invalid"]}'
        end
        before { allow(JSON::Validator).to receive(:fully_validate).and_return(double) }
        it { expect { subject.valid! }.to raise_error(Esplanade::ResponseInvalid, message) }
      end
    end
  end
end
