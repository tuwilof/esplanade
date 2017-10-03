require 'spec_helper'

RSpec.describe Esplanade::Request::Validation do
  subject { described_class.new(raw, doc) }

  let(:raw) { double }
  let(:doc) { double }

  describe '#error' do
    let(:error) { double }
    let(:raw) { double(body: double(to_hash: double)) }
    let(:doc) { double(json_schema: double) }
    before { allow(JSON::Validator).to receive(:fully_validate).and_return(error) }
    it { expect(subject.error).to eq(error) }
  end

  describe '#valid!' do
    before { allow(subject).to receive(:error).and_return([]) }
    it { expect(subject.valid!).to be_nil }

    context 'invalid' do
      let(:raw) { double(method: method, path: path, body: double(to_string: body), error: error) }
      let(:method) { 'method' }
      let(:path) { 'path' }
      let(:body) { 'body' }
      let(:error) { 'error' }

      before { allow(subject).to receive(:error).and_return(error) }

      it do
        expect { subject.valid! }
          .to raise_error(
            Esplanade::RequestInvalid,
            "{:method=>\"#{method}\", :path=>\"#{path}\", :body=>\"#{body}\", :error=>\"#{error}\"}"
          )
      end
    end
  end
end
