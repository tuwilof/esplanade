require 'spec_helper'

RSpec.describe Esplanade::Request::Doc do
  subject { described_class.new(main_documentation, raw) }

  let(:main_documentation) { double }
  let(:raw) { double }

  describe '#tomogram' do
    let(:raw) { double(method: double, path: double) }
    let(:tomogram_request) { double }
    let(:main_documentation) { double(find_request: tomogram_request) }

    it { expect(subject.tomogram).to eq(tomogram_request) }

    context 'no tomogram' do
      let(:main_documentation) { nil }

      it { expect(subject.tomogram).to be_nil }
    end
  end
end
