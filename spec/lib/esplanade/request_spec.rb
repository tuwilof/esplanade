require 'spec_helper'

RSpec.describe Esplanade::Request do
  subject { described_class.new(env, tomogram) }

  let(:env) { {} }
  let(:tomogram) { double }

  describe '#documentation' do
    let(:documentation) { double }
    let(:tomogram) { double(find_request: documentation) }

    it { expect(subject.documentation).to eq(documentation) }

    context 'no tomogram'  do
      let(:tomogram) { nil }

      it { expect(subject.documentation).to be_nil }
    end
  end

  describe '#json_schema' do
    let(:json_schema) { double }

    before { allow(subject).to receive(:documentation).and_return(double(request: json_schema)) }

    it { expect(subject.json_schema).to eq(json_schema) }

    context 'not documented' do
      before { allow(subject).to receive(:documentation).and_return(nil) }

      it { expect(subject.json_schema).to be_nil }
    end
  end

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
      allow(subject).to receive(:json_schema).and_return(json_schema)
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
    let(:tomogram) { double(find_request: nil) }

    it { expect(subject.documented?).to be_falsey }
  end

  describe '#has_json_schema?' do
    before { allow(subject).to receive(:json_schema).and_return(double) }

    it { expect(subject.has_json_schema?).to be_truthy }

    context 'does not have json-schema' do
      before { allow(subject).to receive(:json_schema).and_return({}) }

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
