# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Service' do
  context 'with lazy service but this server does not exist' do
    let!(:klass) do
      Class.new do
        extend Katinguele::Client

        katinguele_service :rickandmortyapi_904a9b, lazy: true
        katinguele_request_options path: 'character/:character_id'
      end
    end

    it do
      expect(Katinguele.configuration.services[:rickandmortyapi_904a9b]).to be_nil
      expect(klass.katinguele_request_attributes).to eq({})
      expect { klass.get }.to raise_error(Katinguele::Client::UnknownService)
    end
  end

  context 'with lazy service but this server exists', :vcr do
    let!(:klass) do
      Class.new do
        extend Katinguele::Client

        katinguele_service :rickandmortyapi_d19e49, lazy: true
        katinguele_request_options path: 'character/:character_id'
      end
    end

    let!(:service) do
      Katinguele.configure do |config|
        config.add_service :rickandmortyapi_d19e49,
                           url: 'rickandmortyapi.com/api',
                           params: { character_id: 7 },
                           protocol: 'https'
      end
    end

    let(:get) { klass.get }

    it do
      expect(Katinguele.configuration.services[:rickandmortyapi_d19e49])
        .to have_attributes(
          after: nil,
          before: nil,
          headers: {},
          logger: false,
          open_timeout: nil,
          params: { character_id: 7 },
          path: nil,
          payload: {},
          protocol: 'https',
          raise_error: false,
          timeout: nil,
          url: 'rickandmortyapi.com/api'
        )
      expect(klass.katinguele_request_attributes).to eq({})
      expect(get).to be_a(Katinguele::Response)
      expect(get.body).to eq(
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
end
