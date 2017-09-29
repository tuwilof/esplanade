require 'spec_helper'

RSpec.describe Esplanade::Response::Raw do
  subject { described_class.new(status, raw_body) }

  let(:status) { double }
  let(:raw_body) { double }

  describe '#body' do
    let(:body) { double }

    before { allow(Esplanade::Response::Raw::Body).to receive(:new).and_return(body) }

    it { expect(subject.body).to eq(body) }
  end
end
