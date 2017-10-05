require 'spec_helper'

RSpec.describe Esplanade::Response do
  subject { described_class.new(request, status, raw_body) }

  let(:request) { double }
  let(:status) { double }
  let(:raw_body) { double }

  describe { it { expect(subject.doc).to be_a(Esplanade::Response::Doc) } }
  describe { it { expect(subject.raw).to be_a(Esplanade::Response::Raw) } }
  describe { it { expect(subject.validation).to be_a(Esplanade::Response::Validation) } }
end
