require 'spec_helper'

RSpec.describe Esplanade::Request::Raw::Body do
  subject { described_class.new(raw_request, env) }
  let(:raw_request) { double(method: 'method', path: 'path', content_type: 'application/json') }
  let(:env) { double }

  describe '#to_string' do
    let(:body) { double }
    let(:env) { { 'rack.input' => double(read: body, rewind: nil) } }
    it { expect(subject.to_string).to eq(body) }
  end

  describe '#reduced_version' do
    let(:body) { 'test' }
    before { allow(subject).to receive(:to_string).and_return(body) }
    it { expect(subject.reduced_version).to eq(body) }

    context 'more than a thousand' do
      let(:body) { '12345678901' * 100 }
      it do
        expect(subject.reduced_version).to eq(
          '1234567890112345678901123456789011234567890112345678901123456789011234567890112345678901'\
          '1234567890112345678901123456789011234567890112345678901123456789011234567890112345678901'\
          '1234567890112345678901123456789011234567890112345678901123456789011234567890112345678901'\
          '1234567890112345678901123456789011234567890112345678901123456789011234567890112345678901'\
          '1234567890112345678901123456789011234567890112345678901123456789011234567890112345678901'\
          '123456789011234567890112345678901123456789011234567890112345...6789011234567890112345678901'\
          '1234567890112345678901123456789011234567890112345678901123456789011234567890112345678901'\
          '1234567890112345678901123456789011234567890112345678901123456789011234567890112345678901'\
          '1234567890112345678901123456789011234567890112345678901123456789011234567890112345678901'\
          '1234567890112345678901123456789011234567890112345678901123456789011234567890112345678901'\
          '1234567890112345678901123456789011234567890112345678901123456789011234567890112345678901'\
          '1234567890112345678901123456789011234567890112345678901123456789011234567890112345678901'\
          '12345678901123456789011234567890112345678901'
        )
      end
    end
  end

  describe '#to_hash' do
    before { allow(subject).to receive(:to_string).and_return('{"state": 1}') }
    it { expect(subject.to_hash).to eq('state' => 1) }

    context 'body nil' do
      let(:message) { '{:method=>"method", :path=>"path", :content_type=>"application/json", :body=>nil}' }
      before { allow(subject).to receive(:to_string).and_return(nil) }
      it { expect { subject.to_hash }.to raise_error(Esplanade::Request::BodyIsNotJson, message) }
    end

    context 'body is empty' do
      let(:message) { '{:method=>"method", :path=>"path", :content_type=>"application/json", :body=>" "}' }
      before { allow(subject).to receive(:to_string).and_return(' ') }
      it { expect { subject.to_hash }.to raise_error(Esplanade::Request::BodyIsNotJson, message) }
    end

    context 'can not parse body of request' do
      let(:message) { '{:method=>"method", :path=>"path", :content_type=>"application/json", :body=>"{\"state\": 1"}' }
      before { allow(subject).to receive(:to_string).and_return('{"state": 1') }
      it { expect { subject.to_hash }.to raise_error(Esplanade::Request::BodyIsNotJson, message) }
    end
  end
end
