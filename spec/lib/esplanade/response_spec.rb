require 'spec_helper'

RSpec.describe Esplanade::Response do
  subject { described_class.new(status, raw_body, expect_request) }

  let(:status) { double }
  let(:raw_body) { double }
  let(:expect_request) { double }

  describe '#error' do
    let(:json_schemas) { double }
    let(:body) { double }
    let(:error) { double }

    before do
      allow(subject).to receive(:doc).and_return(double(json_schemas: json_schemas))
      allow(subject).to receive(:raw).and_return(double(body: double(to_h: body)))
      allow(JSON::Validator).to receive(:fully_validate).and_return(error)
    end

    context 'one schema' do
      let(:json_schemas) { double(first: {}, size: 1) }

      it { expect(subject.error).to eq(error) }
    end

    context 'there is a valid scheme' do
      let(:json_schemas) { [{}] }
      let(:error) { [] }

      it { expect(subject.error).to eq(error) }
    end

    context 'no valid schemes' do
      let(:json_schemas) { [{}, {}] }
      let(:error) { ['invalid'] }

      it { expect(subject.error).to eq(error) }
    end

    context 'no json-schemas' do
      let(:json_schemas) { nil }

      it { expect(subject.error).to be_nil }
    end

    context 'empty json-schemas' do
      let(:json_schemas) { [] }

      it { expect(subject.error).to be_nil }
    end

    context 'no body' do
      let(:body) { nil }

      it { expect(subject.error).to be_nil }
    end
  end

  describe '#documented?' do
    before { allow(subject).to receive(:doc).and_return(double(tomogram: nil)) }

    it { expect(subject.documented?).to be_falsey }
  end

  describe '#has_json_schemas?' do
    before { allow(subject).to receive(:doc).and_return(double(json_schemas: [double, double])) }

    it { expect(subject.has_json_schemas?).to be_truthy }

    context 'does not have json-schemas' do
      before { allow(subject).to receive(:doc).and_return(double(json_schemas: [double, {}])) }

      it { expect(subject.has_json_schemas?).to be_falsey }
    end
  end

  describe '#body_json?' do
    let(:json) { double }

    before { allow(subject).to receive(:raw).and_return(double(body: double(json?: json))) }

    it { expect(subject.body_json?).to eq(json) }
  end

  describe '#valid??' do
    before { allow(subject).to receive(:error) }

    it { expect(subject.valid?).to be_falsey }
  end
end
