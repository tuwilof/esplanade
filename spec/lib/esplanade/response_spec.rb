require 'spec_helper'

RSpec.describe Esplanade::Response do
  subject { described_class.new(status, raw_body, expect_request) }

  let(:status) { double }
  let(:raw_body) { double }
  let(:expect_request) { double }

  describe '#body' do
    let(:body) { double }

    before { allow(Esplanade::Response::Body).to receive(:craft).and_return(body) }

    it { expect(subject.body).to eq(body) }
  end

  describe '#schemas' do
    let(:schemas) { double }
    let(:expect_request) { double(schema: double(find_responses: schemas)) }

    it { expect(subject.schemas).to eq(schemas) }
  end

  describe '#error' do
    context 'one schema' do
      let(:error) { double }

      before do
        allow(subject).to receive(:schemas).and_return(double(first: {}, size: 1))
        allow(subject).to receive(:body)
        allow(JSON::Validator).to receive(:fully_validate).and_return(error)
      end

      it { expect(subject.error).to eq(error) }
    end

    context 'there is a valid scheme' do
      let(:error) { [] }

      before do
        allow(subject).to receive(:schemas).and_return([{}])
        allow(subject).to receive(:body)
        allow(JSON::Validator).to receive(:fully_validate).and_return(error)
      end

      it { expect(subject.error).to eq(error) }
    end

    context 'no valid schemes' do
      before do
        allow(subject).to receive(:schemas).and_return([{}, {}])
        allow(subject).to receive(:body)
        allow(JSON::Validator).to receive(:fully_validate).and_return(double)
      end

      it { expect(subject.error).to eq(['invalid']) }
    end

    describe '#documented?' do
      before { allow(subject).to receive(:schemas) }

      it { expect(subject.documented?).to be_falsey }
    end

    describe '#valid??' do
      before { allow(subject).to receive(:error) }

      it { expect(subject.valid?).to be_falsey }
    end
  end
end
