require 'spec_helper'

RSpec.describe Esplanade::Response::Validation do
  subject { described_class.new(raw, doc) }

  let(:raw) { double }
  let(:doc) { double }

  describe '#error' do
    context 'one json-schema' do
      let(:error) { double }
      let(:raw) { double(json?: true, body: double(to_h: double)) }
      let(:doc) { double(json_schemas?: true, json_schemas: [double]) }
      before { allow(JSON::Validator).to receive(:fully_validate).and_return(error) }
      it { expect(subject.error).to eq(error) }
    end

    context 'more than one json-schema' do
      let(:raw) { double(json?: true, body: double(to_h: double)) }
      let(:doc) { double(json_schemas?: true, json_schemas: [double, double]) }
      before { allow(JSON::Validator).to receive(:fully_validate).and_return(error) }

      context 'one valid' do
        let(:error) { [] }
        it { expect(subject.error).to eq(error) }
      end

      context 'all invalid' do
        let(:error) { double }
        it { expect(subject.error).to eq(['invalid']) }
      end
    end
  end

  describe '#valid?' do
    before { allow(subject).to receive(:error) }
    it { expect(subject.valid?).to be_falsey }
  end
end
