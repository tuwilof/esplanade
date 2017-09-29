require 'spec_helper'

RSpec.describe Esplanade::Response::Raw do
  subject { described_class.new(status, raw_body) }
  let(:status) { double }
  let(:raw_body) { double }

  describe { it { expect(subject.body).to be_a(Esplanade::Response::Raw::Body) } }
end
