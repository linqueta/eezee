# frozen_string_literal: true

require 'spec_helper'
require 'securerandom'

shared_examples_for :katinguele_client_requester_post do |requester|
  describe 'post', :vcr do
    subject { klass.post(options) }

    let(:success)  { subject.success? }
    let(:code)     { subject.code     }
    let(:body)     { subject.body     }
    let(:timeout)  { subject.timeout? }

    before do
      Katinguele.configure do |config|
        config.add_service :jsonplaceholder,
                           url: 'jsonplaceholder.typicode.com',
                           protocol: 'https'
      end
    end

    let(:klass) do
      Class.new do
        extend Katinguele::Client::Builder
        extend requester

        katinguele_service :jsonplaceholder
        katinguele_request_options path: 'todos'
      end
    end

    context 'with success' do
      let(:options) do
        {
          headers: {
            'Content-Type' => 'application/json'
          },
          payload: {
            title: 'TODO Linqueta'
          }
        }
      end

      it { is_expected.to be_a(Katinguele::Response) }
      it { expect(success).to be_truthy }
      it { expect(code).to eq(201) }
      it { expect(timeout).to be_falsey }
      it { expect(body).to eq(title: 'TODO Linqueta', id: 201) }
    end

    context 'with error' do
      context 'with raise error option' do
        context 'with timeout' do
          context 'without after' do
            let(:options) { { raise_error: true, timeout: 0.1 } }

            it { expect { subject }.to raise_error(Katinguele::TimeoutError) }
          end

          context 'with after' do
            context 'with true response' do
              let(:options) do
                {
                  raise_error: true,
                  timeout: 0.1,
                  after: ->(_req, _res, _err) { true }
                }
              end

              it { is_expected.to be_a(Katinguele::Response) }
              it { expect(success).to be_falsey }
              it { expect(code).to be_nil }
              it { expect(timeout).to be_truthy }
              it { expect(body).to eq({}) }
            end

            context 'with false response' do
              let(:options) do
                {
                  raise_error: true,
                  timeout: 0.1,
                  after: ->(_req, _res, _err) { false }
                }
              end

              it { expect { subject }.to raise_error(Katinguele::TimeoutError) }
            end
          end
        end

        context 'without timeout' do
          let(:options) do
            {
              raise_error: true,
              headers: {
                'Content-Type' => 'application/json'
              },
              path: 'todos/a',
              payload: {
                title: 'TODO Linqueta'
              }
            }
          end

          it { expect { subject }.to raise_error(Katinguele::ResourceNotFoundError) }
        end
      end

      context 'without raise error option' do
        context 'with timeout' do
          let(:options) { { path: 'todos/a', timeout: 0.1 } }

          it { is_expected.to be_a(Katinguele::Response) }
          it { expect(success).to be_falsey }
          it { expect(code).to be_nil }
          it { expect(timeout).to be_truthy }
          it { expect(body).to eq({}) }
        end

        context 'without timeout' do
          let(:options) { { path: 'todos/a' } }

          it { is_expected.to be_a(Katinguele::Response) }
          it { expect(success).to be_falsey }
          it { expect(code).to eq(404) }
          it { expect(timeout).to be_falsey }
          it { expect(body).to eq({}) }
        end
      end
    end
  end
end
