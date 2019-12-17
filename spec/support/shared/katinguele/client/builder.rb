# frozen_string_literal: true

require 'spec_helper'

shared_examples_for :katinguele_client_builder do |builder|
  describe '#katinguele_options' do
    subject { klass&.katinguele_options }

    let(:request) { subject[:request] }
    let(:request_options) { subject[:request_options] }
    let(:service_name) { subject[:service_name] }

    context 'with just extend builder' do
      let(:klass) do
        Class.new do
          extend builder
        end
      end

      it { is_expected.to eq({}) }
    end

    context 'with just request options' do
      let(:klass) do
        Class.new do
          extend builder

          katinguele_request_options raise_error: true,
                                     url: 'https://www.linqueta.com',
                                     headers: { 'Content-Type' => 'application/json' }
        end
      end

      it { is_expected.not_to eq({}) }
      it do
        expect(request_options).to eq(raise_error: true,
                                      url: 'https://www.linqueta.com',
                                      headers: { 'Content-Type' => 'application/json' })
      end
      it { expect(request).to be_a(Katinguele::Request) }
      it do
        expect(request).to have_attributes(raise_error: true,
                                           url: 'https://www.linqueta.com',
                                           headers: { 'Content-Type' => 'application/json' },
                                           urn: 'https://www.linqueta.com')
      end
      it { expect(service_name).to be_nil }
    end

    context 'with just service' do
      context 'with unknown service' do
        let(:klass) do
          Class.new do
            extend builder

            katinguele_service :addresses
          end
        end

        it { expect { klass }.to raise_error(Katinguele::Client::UnknwonService) }
      end

      context 'with known service' do
        before do
          Katinguele.configure do |config|
            config.add_service :linqueta,
                               raise_error: true,
                               url: 'www.linqueta.com',
                               protocol: 'https',
                               headers: { 'Content-Type' => 'application/json' }
          end
        end

        let(:klass) do
          Class.new do
            extend builder

            katinguele_service :linqueta
          end
        end

        it { is_expected.not_to eq({}) }
        it { expect(request_options).to be_nil }
        it { expect(request).to be_a(Katinguele::Request) }
        it do
          expect(request).to have_attributes(raise_error: true,
                                             url: 'www.linqueta.com',
                                             headers: { 'Content-Type' => 'application/json' },
                                             protocol: 'https',
                                             urn: 'https://www.linqueta.com')
        end
        it { expect(service_name).to eq(:linqueta) }
      end
    end

    context 'with request options and service' do
      before do
        Katinguele.configure do |config|
          config.add_service :linqueta,
                             raise_error: true,
                             url: 'www.linqueta.com',
                             protocol: 'https',
                             headers: { 'Content-Type' => 'application/json' }
        end
      end

      let(:klass) do
        Class.new do
          extend builder

          katinguele_service :linqueta
          katinguele_request_options path: 'about',
                                     raise_error: false,
                                     logger: true
        end
      end

      it { is_expected.not_to eq({}) }
      it do
        expect(request_options).to eq(
          path: 'about',
          raise_error: false,
          logger: true
        )
      end
      it { expect(request).to be_a(Katinguele::Request) }
      it do
        expect(request).to have_attributes(raise_error: false,
                                           url: 'www.linqueta.com',
                                           headers: { 'Content-Type' => 'application/json' },
                                           protocol: 'https',
                                           urn: 'https://www.linqueta.com/about',
                                           path: 'about',
                                           logger: true)
      end
      it { expect(service_name).to eq(:linqueta) }
    end
  end
end
