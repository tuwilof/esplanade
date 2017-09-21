require 'spec_helper'

RSpec.describe Esplanade::Request do
  subject { described_class.new(env, tomogram) }

  let(:env) { {} }
  let(:tomogram) { double }

  describe '#method' do
    let(:method) { double }
    let(:env) { { 'REQUEST_METHOD' => method } }

    it { expect(subject.method).to eq(method) }
  end

  describe '#path' do
    let(:path) { double }
    let(:env) { { 'PATH_INFO' => path } }

    it { expect(subject.path).to eq(path) }
  end

  describe '#body' do
    let(:body) { double }

    before { allow(Esplanade::Request::Body).to receive(:craft).and_return(body) }

    it { expect(subject.body).to eq(body) }
  end

  describe '#request_tomogram' do
    let(:request_tomogram) { double }
    let(:tomogram) { double(find_request: request_tomogram) }

    it { expect(subject.request_tomogram).to eq(request_tomogram) }

    context 'no tomogram'  do
      let(:tomogram) { nil }

      it { expect(subject.request_tomogram).to be_nil }
    end
  end

  describe '#json_schema' do
    let(:json_schema) { double }

    before { allow(subject).to receive(:request_tomogram).and_return(double(request: json_schema)) }

    it { expect(subject.json_schema).to eq(json_schema) }

    context 'not documented' do
      before { allow(subject).to receive(:request_tomogram).and_return(nil) }

      it { expect(subject.json_schema).to be_nil }
    end
  end

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
      allow(subject).to receive(:json_schema).and_return(json_schema)
      allow(subject).to receive(:body).and_return(body)
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

  describe '#documented?' do
    let(:tomogram) { double(find_request: nil) }

    it { expect(subject.documented?).to be_falsey }
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
