# frozen_string_literal: true

RSpec.describe Katinguele::Request, type: :model do
  describe '#initialize' do
    subject { described_class.new(params) }

    context 'without any params' do
      let(:params) { {} }

      it { expect { subject }.to raise_error(Katinguele::RequiredFieldError, /url/) }
    end

    context 'with all fields' do
      let(:params) do
        {
          headers: {
            'User-Agent' => 'Katinguele',
            Token: 'Token 2b173033-45fa-459a-afba-9eea79cb75be'
          },
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
          url: 'addresses.linqueta.com'
        }
      end

      it do
        is_expected.to have_attributes(
          params.merge(
            urn: 'https://addresses.linqueta.com/users/10/addresses/15?state=Sao Paulo&country=Brazil'
          )
        )
      end
    end
  end
end
