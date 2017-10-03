require 'spec_helper'

RSpec.describe Esplanade::Request::Raw do
  subject { described_class.new(env) }
  let(:env) { {} }

  describe '#method' do
    let(:method) { double }
    let(:env) { { 'REQUEST_METHOD' => method } }
    it { expect(subject.method).to eq(method) }

    context 'can not get method of request' do
      let(:env) { nil }
      it { expect { subject.method }.to raise_error(Esplanade::RawRequestError) }
    end
  end

  describe '#path' do
    let(:path) { double }
    let(:env) { { 'PATH_INFO' => path } }
    it { expect(subject.path).to eq(path) }

    context 'can not get path of request' do
      let(:env) { nil }
      it { expect { subject.path }.to raise_error(Esplanade::RawRequestError) }
    end
  end

  describe { it { expect(subject.body).to be_a(Esplanade::Request::Raw::Body) } }
end
