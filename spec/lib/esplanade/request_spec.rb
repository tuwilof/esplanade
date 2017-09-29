require 'spec_helper'

RSpec.describe Esplanade::Request do
  subject { described_class.new(env, tomogram) }

  let(:env) { double }
  let(:tomogram) { double }

  describe { it { expect(subject.raw).to be_a(Esplanade::Request::Raw) } }
  describe { it { expect(subject.doc).to be_a(Esplanade::Request::Doc) } }
  describe { it { expect(subject.validation).to be_a(Esplanade::Request::Validation) } }

  describe '#documented?' do
    before { allow(subject).to receive(:doc).and_return(double(tomogram: double)) }

    it { expect(subject.documented?).to be_truthy }

    context 'does not have documentation' do
      before { allow(subject).to receive(:doc).and_return(double(tomogram: nil)) }

      it { expect(subject.documented?).to be_falsey }
    end
  end

  describe '#has_json_schema?' do
    before { allow(subject).to receive(:doc).and_return(double(json_schema: double)) }

    it { expect(subject.has_json_schema?).to be_truthy }

    context 'does not have json-schema' do
      before { allow(subject).to receive(:doc).and_return(double(json_schema: {})) }

      it { expect(subject.has_json_schema?).to be_falsey }
    end
  end

  describe '#body_json?' do
    let(:json) { double }

    before { allow(subject).to receive(:raw).and_return(double(body: double(json?: json))) }

    it { expect(subject.body_json?).to eq(json) }
  end
end
