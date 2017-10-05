require 'spec_helper'

RSpec.describe Esplanade::Request do
  subject { described_class.new(documentation, env) }

  let(:documentation) { double }
  let(:env) { double }

  describe { it { expect(subject.doc).to be_a(Esplanade::Request::Doc) } }
  describe { it { expect(subject.raw).to be_a(Esplanade::Request::Raw) } }
  describe { it { expect(subject.validation).to be_a(Esplanade::Request::Validation) } }
end
