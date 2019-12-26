# frozen_string_literal: true

RSpec.describe Eezee::Request, type: :model do
  describe '#initialize' do
    subject { described_class.new(params) }

    context 'without valid params' do
      context 'without any params' do
        let(:params) { {} }

        it { expect { subject }.to raise_error(Eezee::RequiredFieldError, /url/) }
      end
    end

    context 'with all fields' do
      let(:params) do
        {
          after: ->(_service, _response) { true },
          before: ->(_service) { nil },
          logger: true,
          headers: {
            'User-Agent' => 'Eezee',
            Token: 'Token 2b173033-45fa-459a-afba-9eea79cb75be'
          },
          open_timeout: 2,
          params: {
            user_id: 10,
            address_id: 15,

            state: 'Sao Paulo',
            country: 'Brazil'
          },
          path: 'users/:user_id/addresses/:address_id',
          payload: {
            street: 'Paulista Avenue',
            number: '123',
            state: 'Sao Paulo',
            country: 'Brazil'
          },
          protocol: 'https',
          raise_error: true,
          timeout: 10,
          url: 'www.linqueta.com',
          url_encoded: true
        }
      end

      it do
        is_expected.to have_attributes(
          params.merge(
            uri: 'https://www.linqueta.com/users/10/addresses/15?state=Sao Paulo&country=Brazil'
          )
        )
      end
    end
  end

  describe '#log' do
    subject { request.log }

    let(:request) { build(:request).tap { |r| r.method = :get } }

    after { subject }

    it { expect(Eezee::Logger).to receive(:request).with(request, 'GET') }
  end

  describe '#attributes' do
    subject { request.attributes }

    let(:request) { build(:request) }

    it do
      is_expected.to eq(
        after: nil,
        before: nil,
        logger: true,
        headers: {
          'User-Agent' => 'Eezee',
          Token: 'Token 2b173033-45fa-459a-afba-9eea79cb75be'
        },
        open_timeout: 2,
        params: {
          user_id: 10,
          address_id: 15,

          state: 'Sao Paulo',
          country: 'Brazil'
        },
        path: 'users/:user_id/addresses/:address_id',
        payload: {
          street: 'Paulista Avenue',
          number: '123',
          state: 'Sao Paulo',
          country: 'Brazil'
        },
        protocol: 'https',
        raise_error: true,
        timeout: 10,
        url: 'www.linqueta.com',
        url_encoded: false
      )
    end
  end
end
