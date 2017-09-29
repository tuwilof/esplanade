require 'spec_helper'

RSpec.describe Esplanade::Response::Validation do
  subject { described_class.new(raw, doc) }

  let(:raw) { double }
  let(:doc) { double }

  describe '#error' do
    let(:json_schemas) { double }
    let(:body) { double }
    let(:error) { double }

    before do
      allow(JSON::Validator).to receive(:fully_validate).and_return(error)
    end

    let(:raw) { double(body: double(to_h: body)) }
    let(:doc) { double(json_schemas: json_schemas) }

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

  describe '#valid?' do
    before { allow(subject).to receive(:error) }

    it { expect(subject.valid?).to be_falsey }
  end
end
