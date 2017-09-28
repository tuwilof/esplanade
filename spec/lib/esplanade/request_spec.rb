require 'spec_helper'

RSpec.describe Esplanade::Request do
  subject { described_class.new(env, tomogram) }

  let(:env) { double }
  let(:tomogram) { double }

  describe { it { expect(subject.raw).to be_a(Esplanade::Request::Raw) } }
  describe { it { expect(subject.doc).to be_a(Esplanade::Request::Doc) } }

  describe '#error' do
    let(:body) { { 'a' => 5 } }
    let(:json_schema) do
      {
        'type' => 'object',
        'required' => ['a'],
        'properties' => {
          'a' => { 'type' => 'integer' }
        }
      }
    end
    let(:error) { [] }

    before do
      allow(subject).to receive(:doc).and_return(double(json_schema: json_schema))
      allow(subject).to receive(:raw).and_return(double(body: (double(to_h: body))))
    end

    it { expect(subject.error).to eq(error) }

    context 'invalid body' do
      let(:body) { {} }
      let(:error) do
        [
          "The property '#/' did not contain a required property"\
            " of 'a' in schema 18a1ffbb-4681-5b00-bd15-2c76aee4b28f"
        ]
      end

      it { expect(subject.error).to eq(error) }
    end

    context 'not documented' do
      let(:json_schema) { nil }
      let(:error) { nil }

      it { expect(subject.error).to eq(error) }
    end

    context 'no body' do
      let(:body) { nil }
      let(:error) do
        [
          "The property '#/' of type null did not match the following type:"\
            ' object in schema 18a1ffbb-4681-5b00-bd15-2c76aee4b28f'
        ]
      end

      it { expect(subject.error).to eq(error) }
    end
  end

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

  describe '#valid??' do
    let(:error) { [] }

    before { allow(subject).to receive(:error).and_return(error) }

    it { expect(subject.valid?).to be_truthy }

    context 'invalid' do
      let(:error) do
        [
          "The property '#/' did not contain a required property"\
            " of 'a' in schema 18a1ffbb-4681-5b00-bd15-2c76aee4b28f"
        ]
      end

      it { expect(subject.valid?).to be_falsey }
    end

    context 'not error' do
      let(:error) { nil }

      it { expect(subject.valid?).to be_falsey }
    end
  end
end
