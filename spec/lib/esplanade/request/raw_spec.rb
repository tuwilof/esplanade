require 'spec_helper'

RSpec.describe Esplanade::Request::Raw do
  subject { described_class.new(env) }
  let(:env) { {} }

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

  describe '#content-type' do
    context 'content-Type contain additional parameters' do
      let(:env) { { 'CONTENT_TYPE' => 'application/json; encoding=utf8' } }
      it { expect(subject.content_type).to eq('application/json') }
    end
  end

  describe { it { expect(subject.body).to be_a(Esplanade::Request::Raw::Body) } }
end
