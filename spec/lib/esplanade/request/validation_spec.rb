require 'spec_helper'

RSpec.describe Esplanade::Request::Validation do
  subject { described_class.new(raw, doc) }

  let(:raw) { double }
  let(:doc) { double }

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
      allow(subject).to receive(:raw).and_return(double(body: double(to_h: body)))
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
