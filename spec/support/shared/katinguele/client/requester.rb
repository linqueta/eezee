# frozen_string_literal: true

require 'spec_helper'

shared_examples_for :katinguele_client_requester do |requester|
  describe 'get', :vcr do
    subject { klass.get(options) }

    let(:success)  { subject.success? }
    let(:code)     { subject.code     }
    let(:body)     { subject.body     }
    let(:timeout)  { subject.timeout? }

    before do
      Katinguele.configure do |config|
        config.add_service :rickandmortyapi,
                           url: 'rickandmortyapi.com/api',
                           protocol: 'https'
      end
    end

    let(:klass) do
      Class.new do
        extend Katinguele::Client::Builder
        extend requester

        katinguele_service :rickandmortyapi
        katinguele_request_options path: 'character/:character_id'
      end
    end

    context 'with success' do
      let(:options) { { params: { character_id: 7 } } }

      it { is_expected.to be_a(Katinguele::Response) }
      it { expect(success).to be_truthy }
      it { expect(code).to eq(200) }
      it { expect(timeout).to be_falsey }
      it do
        expect(body).to eq(
          created: '2017-11-04T19:59:20.523Z',
          episode: ['https://rickandmortyapi.com/api/episode/10', 'https://rickandmortyapi.com/api/episode/11'],
          gender: 'Male',
          id: 7,
          image: 'https://rickandmortyapi.com/api/character/avatar/7.jpeg',
          location: { name: 'Testicle Monster Dimension', url: 'https://rickandmortyapi.com/api/location/21' },
          name: 'Abradolf Lincler',
          origin: { name: 'Earth (Replacement Dimension)', url: 'https://rickandmortyapi.com/api/location/20' },
          species: 'Human',
          status: 'unknown',
          type: 'Genetic experiment',
          url: 'https://rickandmortyapi.com/api/character/7'
        )
      end
    end

    context 'with error' do
      context 'with raise error option' do
        context 'with timeout' do
          context 'without after' do
            let(:options) { { params: { character_id: 'a' }, raise_error: true, timeout: 0.1 } }

            it { expect { subject }.to raise_error(Katinguele::TimeoutError) }
          end

          context 'with after' do
            context 'with true response' do
              let(:options) do
                {
                  params: { character_id: 'a' },
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
                  params: { character_id: 'a' },
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
          let(:options) { { params: { character_id: 'a' }, raise_error: true } }

          it { expect { subject }.to raise_error(Katinguele::InternalServerError) }
        end
      end

      context 'without raise error option' do
        context 'with timeout' do
          let(:options) { { params: { character_id: 'a' }, timeout: 0.1 } }

          it { is_expected.to be_a(Katinguele::Response) }
          it { expect(success).to be_falsey }
          it { expect(code).to be_nil }
          it { expect(timeout).to be_truthy }
          it { expect(body).to eq({}) }
        end

        context 'without timeout' do
          let(:options) { { params: { character_id: 'a' } } }

          it { is_expected.to be_a(Katinguele::Response) }
          it { expect(success).to be_falsey }
          it { expect(code).to eq(500) }
          it { expect(timeout).to be_falsey }
          it do
            expect(body).to eq(
              error: 'Hey! that parameter is not allowed, try with a number instead ;)'
            )
          end
        end
      end
    end
  end
end
