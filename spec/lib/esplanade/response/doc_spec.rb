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
      it { expect { subject.tomogram }.to raise_error(Esplanade::DocResponseError) }
    end

    context 'does not have request documentation' do
      let(:request) { double(doc: nil) }
      it { expect { subject.tomogram }.to raise_error(Esplanade::DocResponseError) }
    end

    context 'does not have responses' do
      let(:request) { double(doc: double(responses: nil)) }
      it { expect { subject.tomogram }.to raise_error(Esplanade::DocResponseError) }
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
      it { expect { subject.json_schemas }.to raise_error(Esplanade::DocResponseError) }
    end

    context 'json-schemas is empty' do
      let(:message) { '{:request=>{:method=>"method", :path=>"path"}, :status=>"status"}' }
      let(:request) { double(raw: double(method: 'method', path: 'path')) }
      before do
        allow(subject).to receive(:tomogram).and_return([])
        allow(subject).to receive(:status).and_return('status')
      end
      it { expect { subject.json_schemas }.to raise_error(Esplanade::DocResponseWithoutJsonSchemas, message) }
    end

    context 'not all json-schema' do
      let(:message) { '{:request=>{:method=>"method", :path=>"path"}, :status=>"status"}' }
      let(:request) { double(raw: double(method: 'method', path: 'path')) }
      before do
        allow(subject).to receive(:tomogram).and_return([{ 'body' => {} }])
        allow(subject).to receive(:status).and_return('status')
      end
      it { expect { subject.json_schemas }.to raise_error(Esplanade::DocResponseWithoutJsonSchemas, message) }
    end
  end

  describe '#status' do
    let(:status) { double }
    before { allow(subject).to receive(:tomogram).and_return('status' => status) }
    it { expect(subject.status).to eq(status) }
  end
end
