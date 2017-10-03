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
      it { expect { subject.tomogram }.to raise_error(Esplanade::DocError) }
    end
  end

  describe '#json_schema' do
    let(:json_schema) { double }
    before { allow(subject).to receive(:tomogram).and_return(double(request: json_schema)) }
    it { expect(subject.json_schema).to eq(json_schema) }

    context 'does not have tomogram' do
      before { allow(subject).to receive(:tomogram).and_return(nil) }
      it { expect { subject.json_schema }.to raise_error(Esplanade::DocError) }
    end
  end

  describe '#method' do
    let(:method) { double }
    before { allow(subject).to receive(:tomogram).and_return(double(method: method)) }
    it { expect(subject.method).to eq(method) }

    context 'does not have tomogram' do
      before { allow(subject).to receive(:tomogram).and_return(nil) }
      it { expect { subject.method }.to raise_error(Esplanade::DocError) }
    end
  end

  describe '#path' do
    let(:path) { double }
    before { allow(subject).to receive(:tomogram).and_return(double(path: double(to_s: path))) }
    it { expect(subject.path).to eq(path) }

    context 'does not have tomogram' do
      before { allow(subject).to receive(:tomogram).and_return(nil) }
      it { expect { subject.path }.to raise_error(Esplanade::DocError) }
    end
  end

  describe '#responses' do
    let(:responses) { double }
    before { allow(subject).to receive(:tomogram).and_return(double(responses: responses)) }
    it { expect(subject.responses).to eq(responses) }

    context 'does not have tomogram' do
      before { allow(subject).to receive(:tomogram).and_return(nil) }
      it { expect { subject.responses }.to raise_error(Esplanade::DocError) }
    end
  end

  describe '#present?' do
    before { allow(subject).to receive(:tomogram).and_return(double) }
    it { expect(subject.present?).to be_truthy }

    context 'does not have tomogram' do
      before { allow(subject).to receive(:tomogram).and_return(nil) }
      it { expect(subject.present?).to be_falsey }
    end
  end

  describe '#json_schema?' do
    before { allow(subject).to receive(:json_schema).and_return(double) }
    it { expect(subject.json_schema?).to be_truthy }

    context 'does not have json-schema' do
      before { allow(subject).to receive(:json_schema).and_return({}) }
      it { expect(subject.json_schema?).to be_falsey }
    end
  end
end
