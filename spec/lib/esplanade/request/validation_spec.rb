require 'spec_helper'

RSpec.describe Esplanade::Request::Validation do
  subject { described_class.new(raw, doc) }

  let(:raw) { double }
  let(:doc) { double }

  describe '#error' do
    let(:error) { double }
    let(:raw) { double(body: double(to_h: double)) }
    let(:doc) { double(json_schema: double) }
    before { allow(JSON::Validator).to receive(:fully_validate).and_return(error) }
    it { expect(subject.error).to eq(error) }

    context 'does not have json-schema' do
      let(:doc) { double(json_schema: nil) }
      it { expect(subject.error).to be_nil }
    end
  end

  describe '#valid?' do
    before { allow(subject).to receive(:error).and_return([]) }
    it { expect(subject.valid?).to be_truthy }

    context 'invalid' do
      before { allow(subject).to receive(:error).and_return(double) }
      it { expect(subject.valid?).to be_falsey }
    end
  end

  describe '#valid!' do
    before { allow(subject).to receive(:error).and_return([]) }
    it { expect(subject.valid!).to be_nil }

    context 'invalid' do
      let(:raw) { double(method: method, path: path, body: double(to_s: body), error: error) }
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
