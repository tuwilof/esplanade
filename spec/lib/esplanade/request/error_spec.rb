require 'spec_helper'

RSpec.describe Esplanade::Request::Error do
  describe '.unsuitable' do
    let(:message) do
      "[\"The property '#/' did not contain a required property"\
        " of 'name' in schema 2801c7c4-6060-529e-84ae-c709b8c3f24c\"]"
    end

    it 'returns response' do
      expect(described_class.unsuitable(message))
        .to eq(
          [
            '400',
            { 'Content-Type' => 'application/json; charset=utf-8' },
            [
              "{\"error\":[\"The property '#/' did not contain a required property"\
                " of 'name' in schema 2801c7c4-6060-529e-84ae-c709b8c3f24c\"]}"
            ]
          ]
        )
    end
  end

  describe '.not_documented' do
    it 'returns response' do
      expect(described_class.not_documented)
        .to eq(
          [
            '400',
            { 'Content-Type' => 'application/json; charset=utf-8' },
            ['{"error":["Not documented"]}']
          ]
        )
    end
  end
end
