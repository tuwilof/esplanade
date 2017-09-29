require 'spec_helper'

RSpec.describe Esplanade::Response do
  subject { described_class.new(status, raw_body, expect_request) }

  let(:status) { double }
  let(:raw_body) { double }
  let(:expect_request) { double }

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
end
