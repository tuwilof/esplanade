require 'spec_helper'

RSpec.describe Esplanade::Request::Doc do
  subject { described_class.new(main_documentation, raw) }
  let(:main_documentation) { double }
  let(:raw) { double }

  describe '#tomogram' do
    let(:tomogram) { double }
    let(:main_documentation) { double(find_request: tomogram) }
    let(:raw) { double(method: double, path: double) }
    it { expect(subject.tomogram).to eq(tomogram) }

    context 'does not have main documentation' do
      let(:main_documentation) { nil }
      it { expect { subject.tomogram }.to raise_error(Esplanade::DocRequestError) }
    end

    context 'request not documented' do
      let(:tomogram) { nil }
      let(:raw) { double(method: 'method', path: 'path') }
      let(:message) { '{:method=>"method", :path=>"path"}' }
      it { expect { subject.tomogram }.to raise_error(Esplanade::Request::NotDocumented, message) }
    end
  end

  describe '#json_schema' do
    let(:json_schema) { double }
    before { allow(subject).to receive(:tomogram).and_return(double(request: json_schema)) }
    it { expect(subject.json_schema).to eq(json_schema) }
  end

  describe '#method' do
    let(:method) { double }
    before { allow(subject).to receive(:tomogram).and_return(double(method: method)) }
    it { expect(subject.method).to eq(method) }
  end

  describe '#path' do
    let(:path) { double }
    before { allow(subject).to receive(:tomogram).and_return(double(path: double(to_s: path))) }
    it { expect(subject.path).to eq(path) }
  end

  describe '#responses' do
    let(:responses) { double }
    before { allow(subject).to receive(:tomogram).and_return(double(responses: responses)) }
    it { expect(subject.responses).to eq(responses) }

    context 'request not documented' do
      before { allow(subject).to receive(:tomogram).and_raise(Esplanade::Request::NotDocumented) }
      it { expect(subject.responses).to eq([]) }
    end
  end
end
