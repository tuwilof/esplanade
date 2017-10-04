require 'spec_helper'

RSpec.describe Esplanade::Response::Doc do
  subject { described_class.new(request, raw_status) }
  let(:request) { double }
  let(:raw_status) { double }

  describe '#tomogram' do
    let(:tomogram) { { 'status' => raw_status } }
    let(:raw_status) { double }
    let(:request) { double(doc: double(responses: [tomogram])) }
    it { expect(subject.tomogram).to eq(tomogram) }

    context 'does not have request' do
      let(:request) { nil }
      it { expect { subject.tomogram }.to raise_error(Esplanade::DocError) }
    end

    context 'does not have request documentation' do
      let(:request) { double(doc: nil) }
      it { expect { subject.tomogram }.to raise_error(Esplanade::DocError) }
    end

    context 'does not have responses' do
      let(:request) { double(doc: double(responses: nil)) }
      it { expect { subject.tomogram }.to raise_error(Esplanade::DocError) }
    end

    context 'response not documented' do
      let(:tomogram) { { 'status' => double } }
      let(:raw_status) { 'status' }
      let(:request) { double(doc: double(responses: [tomogram]), raw: double(method: 'method', path: 'path')) }
      let(:message) { '{:request=>{:method=>"method", :path=>"path"}, :status=>"status"}' }
      it { expect { subject.tomogram }.to raise_error(Esplanade::ResponseNotDocumented, message) }
    end
  end

  describe '#json_schemas' do
    let(:json_schema) { double }
    before { allow(subject).to receive(:tomogram).and_return([{ 'body' => json_schema }]) }
    it { expect(subject.json_schemas).to eq([json_schema]) }

    context 'does not have responses' do
      before { allow(subject).to receive(:tomogram).and_return(nil) }
      it { expect(subject.json_schemas).to be_nil }
    end
  end

  describe '#status' do
    let(:status) { double }
    before { allow(subject).to receive(:tomogram).and_return('status' => status) }
    it { expect(subject.status).to eq(status) }
  end

  describe '#present?' do
    before { allow(subject).to receive(:tomogram).and_return(double) }
    it { expect(subject.present?).to be_truthy }

    context 'does not have tomogram' do
      before { allow(subject).to receive(:tomogram).and_return(nil) }
      it { expect(subject.present?).to be_falsey }
    end

    context 'tomogram is empty' do
      before { allow(subject).to receive(:tomogram).and_return([]) }
      it { expect(subject.present?).to be_falsey }
    end
  end

  describe '#json_schemas?' do
    before { allow(subject).to receive(:json_schemas).and_return([double, double]) }
    it { expect(subject.json_schemas?).to be_truthy }

    context 'does not have json-schemas' do
      before { allow(subject).to receive(:json_schemas).and_return(nil) }
      it { expect(subject.json_schemas?).to be_falsey }
    end

    context 'json-schemas is empty' do
      before { allow(subject).to receive(:json_schemas).and_return([]) }
      it { expect(subject.json_schemas?).to be_falsey }
    end

    context 'not all json-schema' do
      before { allow(subject).to receive(:json_schemas).and_return([double, {}]) }
      it { expect(subject.json_schemas?).to be_falsey }
    end
  end
end
