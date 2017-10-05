require 'spec_helper'

RSpec.describe Esplanade::Response::Raw do
  subject { described_class.new(request, raw_status, raw_body) }
  let(:request) { double }
  let(:raw_status) { double }
  let(:raw_body) { double }

  describe '#status' do
    let(:status) { double }
    let(:raw_status) { double(to_s: status) }
    it { expect(subject.status).to eq(status) }
  end

  describe { it { expect(subject.body).to be_a(Esplanade::Response::Raw::Body) } }
end
