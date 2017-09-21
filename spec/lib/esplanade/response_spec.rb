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

  describe '#response_tomograms' do
    let(:response_tomograms) { double }
    let(:request_tomogram) { double(find_responses: response_tomograms) }
    let(:expect_request) { double(request_tomogram: request_tomogram) }

    it { expect(subject.response_tomograms).to eq(response_tomograms) }

    context 'no request ' do
      let(:expect_request) { nil }

      it { expect(subject.response_tomograms).to be_nil }
    end

    context 'request not documented' do
      let(:request_tomogram) { nil }

      it { expect(subject.response_tomograms).to be_nil }
    end
  end

  describe '#json_schemas' do
    let(:json_schema) { double }

    before do
      allow(subject).to receive(:response_tomograms)
        .and_return([{ 'body' => json_schema }])
    end

    it { expect(subject.json_schemas).to eq([json_schema]) }

    context 'not documented' do
      before { allow(subject).to receive(:response_tomograms).and_return(nil) }

      it { expect(subject.json_schemas).to be_nil }
    end
  end

  describe '#error' do
    let(:json_schemas) { double }
    let(:body) { double }
    let(:error) { double }

    before do
      allow(subject).to receive(:json_schemas).and_return(json_schemas)
      allow(subject).to receive(:body).and_return(body)
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

    context 'no body' do
      let(:body) { nil }

      it { expect(subject.error).to be_nil }
    end
  end

  describe '#documented?' do
    before { allow(subject).to receive(:response_tomograms) }

    it { expect(subject.documented?).to be_falsey }
  end

  describe '#valid??' do
    before { allow(subject).to receive(:error) }

    it { expect(subject.valid?).to be_falsey }
  end
end
