require 'spec_helper'

RSpec.describe Esplanade::Middleware do
  context 'new' do
    let(:app) { double }
    let(:ok) { [response.status, nil, response.body] }

    subject do
      described_class.new(app)
    end

    before do
      allow(Esplanade).to receive(:configuration).and_return(
        double(
          tomogram: tomogram,
          skip_not_documented: skip_not_documented,
          validation_requests: validation_requests,
          validation_response: validation_response
        )
      )
      allow(app).to receive(:call).and_return(ok)
    end
    let(:skip_not_documented) { true }
    let(:validation_requests) { true }
    let(:validation_response) { true }

    describe '#call' do
      let(:request_json_schema) do
        {
          "$schema": 'http://json-schema.org/draft-04/schema#',
          "type": 'object',
          "properties": {
            "example": {
              "type": 'string'
            }
          },
          "required": [
            'example'
          ]
        }
      end
      let(:response_json_schema) do
        {
          "$schema": 'http://json-schema.org/draft-04/schema#',
          "type": 'object',
          "properties": {
            "example": {
              "type": 'string'
            }
          },
          "required": [
            'example'
          ]
        }
      end
      let(:body_request) { '{"example":""}' }
      let(:body_response) { ['{"example":""}'] }
      let(:doc_response) do
        {
          'status' => '200',
          'body' => response_json_schema
        }
      end
      let(:doc_responses) { [doc_response, doc_response] }
      let(:tomogram) do
        MultiJson.dump(
          [
            {
              'path' => '/status',
              'method' => 'POST',
              'request' => request_json_schema,
              'responses' => doc_responses
            }
          ]
        )
      end
      let(:request_path) { '/status' }
      let(:response_status) { 200 }
      let(:request) do
        {
          'REQUEST_METHOD' => 'POST',
          'PATH_INFO' => request_path,
          'rack.input' => double(read: body_request)
        }
      end
      let(:response) { double(status: response_status, body: body_response) }

      context 'request and response is not valid ' do
        let(:body_request) { '{}' }
        let(:body_response) { '{}' }

        context 'but do not need to validate' do
          let(:validation_requests) { false }
          let(:validation_response) { false }

          it 'does not return an error' do
            expect(subject.call(request)).to eq(ok)
          end
        end
      end

      context 'request is not documented' do
        let(:request_path) { '/pokemons' }

        context 'but be sure to document' do
          let(:skip_not_documented) { false }

          it 'returns an error Request::NotDocumented' do
            expect(subject.call(request)).to eq(
              ['400', { 'Content-Type' => 'application/json; charset=utf-8' }, ['{"error":["Not documented"]}']]
            )
          end
        end
      end

      context 'request is not valid' do
        let(:body_request) { '{}' }

        it 'returns an error Request::Unsuitable' do
          expect(subject.call(request)).to eq(
            [
              '400',
              { 'Content-Type' => 'application/json; charset=utf-8' },
              [
                "{\"error\":[\"The property '#/' did not contain a required property"\
                " of 'example' in schema 9edf3679-75e7-5598-b0f6-32c6aecd39cd\"]}"
              ]
            ]
          )
        end
      end

      context 'response is not valid ' do
        let(:body_response) { '{}' }

        context 'but do not need to validate' do
          let(:validation_response) { false }

          it 'does not return an error' do
            expect(subject.call(request)).to eq(ok)
          end
        end
      end

      context 'response is not documented' do
        let(:response_status) { '400' }

        context 'but be sure to document' do
          let(:skip_not_documented) { false }

          it 'returns an error Response::NotDocumented' do
            expect(subject.call(request)).to eq(
              ['500', { 'Content-Type' => 'application/json; charset=utf-8' }, ['{"error":["Not documented"]}']]
            )
          end
        end
      end

      context 'response is not valid' do
        context 'empty' do
          let(:body_response) { [] }

          it 'returns an error Response::Unsuitable' do
            expect(subject.call(request)).to eq(
              ['500', { 'Content-Type' => 'application/json; charset=utf-8' }, ['{"error":["invalid"]}']]
            )
          end
        end

        context 'invalid and one response' do
          let(:body_response) { ['{'] }
          let(:doc_responses) { [doc_response] }

          it 'returns an error Response::Unsuitable' do
            expect(subject.call(request)).to eq(
              [
                '500',
                { 'Content-Type' => 'application/json; charset=utf-8' },
                [
                  "{\"error\":[\"The property '#/' of type String did not match the following"\
                  ' type: object in schema 9edf3679-75e7-5598-b0f6-32c6aecd39cd"]}'
                ]
              ]
            )
          end
        end
      end

      it 'does not return an error' do
        expect(subject.call(request)).to eq([200, nil, ['{"example":""}']])
      end
    end
  end
end
