# frozen_string_literal: true

RSpec.describe Eezee::Response, type: :model do
  describe 'methods', :vcr do
    subject { described_class.new(param) }

    let(:body)     { subject.body     }
    let(:success)  { subject.success? }
    let(:code)     { subject.code     }
    let(:original) { subject.original }
    let(:timeout)  { subject.timeout? }

    context 'with faraday response' do
      context 'with success' do
        let(:param) { Faraday.get('https://rickandmortyapi.com/api/character/7') }

        it do
          expect(body).to eq(
            id: 7,
            name: 'Abradolf Lincler',
            status: 'unknown',
            species: 'Human',
            type: 'Genetic experiment',
            gender: 'Male',
            origin: { name: 'Earth (Replacement Dimension)', url: 'https://rickandmortyapi.com/api/location/20' },
            location: { name: 'Testicle Monster Dimension', url: 'https://rickandmortyapi.com/api/location/21' },
            image: 'https://rickandmortyapi.com/api/character/avatar/7.jpeg',
            episode: ['https://rickandmortyapi.com/api/episode/10', 'https://rickandmortyapi.com/api/episode/11'],
            url: 'https://rickandmortyapi.com/api/character/7',
            created: '2017-11-04T19:59:20.523Z'
          )
        end
        it { expect(success).to be_truthy }
        it { expect(code).to eq(200) }
        it { expect(original).to eq(param) }
        it { expect(timeout).to be_falsey }
      end

      context 'with failure' do
        let(:param) { Faraday.get('https://rickandmortyapi.com/api/characters') }

        it { expect(body).to eq(error: 'There is nothing here.') }
        it { expect(success).to be_falsey }
        it { expect(code).to eq(404) }
        it { expect(original).to eq(param) }
        it { expect(timeout).to be_falsey }
      end

      context 'with faraday null response' do
        let(:param) { Faraday.get('https://rickandmortyapi.com/api/characters') }

        before { allow_any_instance_of(described_class).to receive(:faraday_response) }

        it { expect(body).to eq({}) }
      end

      context 'with faraday empty response' do
        let(:param) { Faraday.get('https://rickandmortyapi.com/api/characters') }

        before { allow_any_instance_of(described_class).to receive(:faraday_response).and_return('') }

        it { expect(body).to eq({}) }
      end

      context 'with invalid faraday response' do
        let(:param) { Faraday.get('https://rickandmortyapi.com/api/characters') }

        before { allow_any_instance_of(described_class).to receive(:faraday_response).and_return('html') }

        it { expect(body).to eq(response: 'html') }
      end
    end

    context 'with faraday error' do
      let(:param) do
        client.get
      rescue StandardError => e
        e
      end

      let(:client) do
        Faraday.new('https://rickandmortyapi.com/api/characters') do |config|
          config.use(Faraday::Response::RaiseError)
          config.adapter(Faraday.default_adapter)
          config.options[:timeout] = timeout_param
        end
      end

      let(:timeout_param) { 10 }

      context 'without timeout error' do
        it { expect(body).to eq(error: 'There is nothing here.') }
        it { expect(success).to be_falsey }
        it { expect(code).to eq(404) }
        it { expect(original).to eq(param) }
        it { expect(timeout).to be_falsey }
      end

      context 'with timeout error' do
        let(:timeout_param) { 0.1 }

        it { expect(body).to eq({}) }
        it { expect(success).to be_falsey }
        it { expect(code).to eq(nil) }
        it { expect(original).to eq(param) }
        it { expect(timeout).to be_truthy }
      end

      context 'with faraday null response' do
        before { allow_any_instance_of(described_class).to receive(:faraday_response) }

        it { expect(body).to eq({}) }
      end

      context 'with faraday empty response' do
        before { allow_any_instance_of(described_class).to receive(:faraday_response).and_return('') }

        it { expect(body).to eq({}) }
      end
    end
  end

  describe '#log' do
    subject { response.log }

    let(:response) { Eezee::Response.new(nil) }

    before do
      allow(response).to receive(:body).and_return(error: 'some error')
      allow(response).to receive(:code).and_return(400)
    end

    after { subject }

    it { expect(Eezee::Logger).to receive(:response).with(response) }
  end
end
