require 'spec_helper'

RSpec.describe Esplanade::Request::Doc do
  subject { described_class.new(main_documentation, raw) }
  let(:main_documentation) { double }
  let(:raw) { double }

  describe '#tomogram' do
    let(:tomogram) { double }
    let(:main_documentation) { double(find_request_with_content_type: tomogram, prefix_match?: true) }
    let(:raw) { double(method: double, path: double, query: double, content_type: double) }
    it { expect(subject.tomogram).to eq(tomogram) }

    context 'prefix not match' do
      let(:main_documentation) { double(prefix_match?: false) }
      let(:raw) { double(method: 'method', path: 'path', raw_path: 'path', content_type: 'content_type') }
      let(:message) { '{:method=>"method", :path=>"path", :raw_path=>"path", :content_type=>"content_type"}' }
      it { expect { subject.tomogram }.to raise_error(Esplanade::Request::PrefixNotMatch, message) }
    end

    context 'request not documented' do
      let(:tomogram) { nil }
      let(:raw) { double(method: 'method', path: 'path', raw_path: 'path', content_type: 'content_type') }
      let(:message) { '{:method=>"method", :path=>"path", :raw_path=>"path", :content_type=>"content_type"}' }
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
      before do
        allow(subject).to receive(:tomogram).and_raise(
          Esplanade::Request::NotDocumented.new(method: 'method', path: 'path', raw_path: 'path', content_type: 'content_type')
        )
      end
      it { expect(subject.responses).to eq([]) }
    end
  end
end
