require 'spec_helper'

RSpec.describe Esplanade::Response::Doc do
  subject { described_class.new(request, raw) }
  let(:request) { double }
  let(:raw) { double }

  describe '#tomogram' do
    let(:raw) { double(status: raw_status) }
    let(:tomogram) { { 'status' => raw_status } }
    let(:raw_status) { double }
    let(:request) { double(doc: double(responses: [tomogram])) }
    it { expect(subject.tomogram).to eq([tomogram]) }

    context 'responses are empty' do
      let(:request) { double(doc: double(responses: []), raw: double(method: 'method', path: 'path', raw_path: 'path')) }
      let(:raw_status) { 'status' }
      let(:message) { '{:request=>{:method=>"method", :path=>"path", :raw_path=>"path"}, :status=>"status"}' }
      it { expect { subject.tomogram }.to raise_error(Esplanade::Response::NotDocumented, message) }
    end

    context 'response not documented' do
      let(:tomogram) { { 'status' => double } }
      let(:raw_status) { 'status' }
      let(:request) { double(doc: double(responses: [tomogram]), raw: double(method: 'method', path: 'path', raw_path: 'path')) }
      let(:message) { '{:request=>{:method=>"method", :path=>"path", :raw_path=>"path"}, :status=>"status"}' }
      it { expect { subject.tomogram }.to raise_error(Esplanade::Response::NotDocumented, message) }
    end
  end

  describe '#json_schemas' do
    let(:json_schema) { double }
    before { allow(subject).to receive(:tomogram).and_return([{ 'body' => json_schema }]) }
    it { expect(subject.json_schemas).to eq([json_schema]) }
  end

  describe '#status' do
    let(:status) { double }
    before { allow(subject).to receive(:tomogram).and_return('status' => status) }
    it { expect(subject.status).to eq(status) }
  end
end
